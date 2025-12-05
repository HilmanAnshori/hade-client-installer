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

for asset in release.get("assets", []):
    name = asset.get("name", "").lower()
    if name.endswith(".deb") and "amd64" in name:
        print(asset.get("browser_download_url"))
        sys.exit(0)

sys.exit("Unable to find an amd64 Debian asset in the latest RustDesk release.")
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
