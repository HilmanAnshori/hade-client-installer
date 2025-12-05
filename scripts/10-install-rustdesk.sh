#!/usr/bin/env bash
if ! set -euo pipefail 2>/dev/null; then
  set -eu
fi

if command -v rustdesk >/dev/null 2>&1; then
  echo "RustDesk already installed, skipping."
  exit 0
fi

if ! command -v curl >/dev/null 2>&1; then
  sudo apt update
  sudo apt install -y curl
fi

echo "Resolving latest RustDesk release..."
asset_url=$(
  python3 - <<'PY'
import json, sys, urllib.request

try:
    with urllib.request.urlopen("https://api.github.com/repos/rustdesk/rustdesk/releases/latest") as resp:
        release = json.load(resp)
except Exception as e:
    sys.exit(f"ERROR: Unable to query GitHub releases: {e}")

defs = []
for asset in release.get("assets", []):
    name = asset.get("name", "")
    lower = name.lower()
    if not lower.endswith(".deb"):
        continue
    candidates = (
        ("linux" in lower),
        ("amd64" in lower or "x86_64" in lower or "amd64" in lower),
        "arm" not in lower,
    )
    defs.append((candidates, asset.get("browser_download_url"), name))

if not defs:
    sys.exit("Unable to find a Debian (.deb) asset in the latest RustDesk release.")

defs.sort(reverse=True)
best = defs[0]
print(best[1])
PY
) || true

if [ -z "$asset_url" ]; then
  echo "Unable to find a RustDesk debian asset. Check https://github.com/rustdesk/rustdesk/releases manually."
  exit 1
fi

temp_deb=$(mktemp --suffix=.deb)
trap 'rm -f "$temp_deb"' EXIT

echo "Downloading RustDesk from $asset_url..."
curl -L -o "$temp_deb" "$asset_url"

echo "Installing RustDesk..."
sudo apt install -y "$temp_deb"

cat <<'EOF'
RustDesk has been installed. Launch it via the desktop menu or run `rustdesk` from the terminal.
EOF
