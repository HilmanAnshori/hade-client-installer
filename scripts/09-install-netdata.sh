#!/usr/bin/env bash
if ! set -euo pipefail 2>/dev/null; then
  set -eu
fi

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

echo "Configuring Netdata streaming client..."
sudo tee /etc/netdata/stream.conf >/dev/null <<'EOF'
[stream]
    enabled = yes
    destination = hade-app:19999  # IP Tailscale Master
    api key = b0590d13-da0e-4dc2-add6-57b0bf69de0b
EOF

echo "Restarting Netdata to apply stream configuration..."
sudo systemctl restart netdata

cat <<'EOF'
Netdata dashboard is now exposed on http://localhost:19999. Use an SSH tunnel if you need to reach it remotely.
EOF
