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

AUTH_KEY="${TAILSCALE_AUTH_KEY:-}"
if [ -n "$AUTH_KEY" ]; then
  echo "Authenticating with provided auth key..."
  sudo tailscale up --auth-key="$AUTH_KEY"
else
  echo "No TAILSCALE_AUTH_KEY provided. Run 'sudo tailscale up --auth-key=...'' manually once you obtain a key."
fi

if [ -n "$AUTH_KEY" ]; then
  cat <<'EOF'
Tailscale is now installed and authenticated. Verify the device appears in your Tailnet.
EOF
else
  cat <<'EOF'
Tailscale is installed but not yet authenticated. Run `sudo tailscale up --auth-key=...` when you obtain your Tailnet auth key.
EOF
fi
