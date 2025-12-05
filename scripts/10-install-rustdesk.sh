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
release_json=$(curl -fsSL https://api.github.com/repos/rustdesk/rustdesk/releases/latest)
asset_url=$(echo "$release_json" | grep browser_download_url | grep linux | grep amd64 | grep '.deb' | head -n 1 | cut -d '"' -f4)

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
