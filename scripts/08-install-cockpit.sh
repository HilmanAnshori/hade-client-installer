#!/usr/bin/env bash
set -euo pipefail

if command -v cockpit >/dev/null 2>&1; then
  echo "Cockpit already installed, skipping."
else
  sudo apt update
  sudo apt install -y cockpit
fi

echo "Enabling cockpit.socket and making sure it starts on boot..."
sudo systemctl enable --now cockpit.socket

cat <<'EOF'
Cockpit is now running on https://localhost:9090. Open your browser and authenticate with a sudo-capable account.
EOF
