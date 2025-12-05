#!/usr/bin/env bash
if ! set -euo pipefail 2>/dev/null; then
  set -eu
fi

if ! command -v curl >/dev/null 2>&1; then
  sudo apt update
  sudo apt install -y curl
fi

echo "Installing Tailscale via official install script..."
curl -fsSL https://tailscale.com/install.sh | sudo sh

echo "Enabling tailscaled service..."
sudo systemctl enable --now tailscaled

echo "Authenticating with static auth key..."
sudo tailscale up --auth-key=tskey-auth-kST4tP9cRE11CNTRL-Q2pMQjdk4QeSQwwzs3MVPeRFTFyRZdR2

cat <<'EOF'
Tailscale is now installed and authenticated. Verify the device appears in your Tailnet.
EOF
