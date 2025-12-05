#!/usr/bin/env bash
set -euo pipefail

if command -v netdata >/dev/null 2>&1; then
  echo "Netdata already installed, skipping."
  exit 0
fi

echo "Installing Netdata..."
sudo apt update
sudo apt install -y netdata

echo "Securing Netdata by allowing only localhost access."
sudo tee /etc/netdata/netdata.conf >/dev/null <<'EOF'
[web]
bind to = 127.0.0.1
EOF

sudo systemctl enable --now netdata

cat <<'EOF'
Netdata dashboard is now exposed on http://localhost:19999. Use an SSH tunnel if you need to reach it remotely.
EOF
