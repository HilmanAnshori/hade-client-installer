#!/usr/bin/env bash
set -euo pipefail

if command -v tailscale >/dev/null 2>&1; then
  echo "tailscale already installed, skipping."
  exit 0
fi

if [ -f /etc/os-release ]; then
  source /etc/os-release
  OS_NAME="${ID_LIKE:-$ID}"
else
  OS_NAME=""
fi

if ! command -v curl >/dev/null 2>&1; then
  sudo apt update
  sudo apt install -y curl
fi

echo "Installing Tailscale via official install script..."
curl -fsSL https://tailscale.com/install.sh | sudo sh

echo "Enabling tailscaled service..."
sudo systemctl enable --now tailscaled

cat <<'EOF'
Run `sudo tailscale up` once on this machine to connect it to your Tailnet.
EOF
