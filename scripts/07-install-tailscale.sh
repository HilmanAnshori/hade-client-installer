#!/usr/bin/env bash
if ! set -euo pipefail 2>/dev/null; then
  set -eu
fi

if command -v tailscale >/dev/null 2>&1; then
  echo "Tailscale already installed."
else
  if ! command -v curl >/dev/null 2>&1; then
    sudo apt update
    sudo apt install -y curl
  fi

  echo "Installing Tailscale via official install script..."
  curl -fsSL https://tailscale.com/install.sh | sudo sh
fi

echo "Enabling tailscaled service..."
sudo systemctl enable --now tailscaled

AUTH_KEY="${TAILSCALE_AUTH_KEY:-}"

if [ -n "$AUTH_KEY" ]; then
  echo "Authenticating with provided auth key..."
  if sudo tailscale up --auth-key="$AUTH_KEY"; then
    cat <<'EOF'
Tailscale is now installed and authenticated. Verify the device appears in your Tailnet.
EOF
  else
    cat <<'EOF'
Authentication failed; check the auth key in TAILSCALE_AUTH_KEY and rerun `sudo tailscale up --auth-key=...`.
EOF
  fi
else
  cat <<'EOF'
Tailscale is installed but not yet authenticated. Run `sudo tailscale up --auth-key=...` when you obtain your Tailnet auth key.
EOF
fi
