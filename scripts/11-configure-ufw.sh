#!/usr/bin/env bash
if ! set -euo pipefail 2>/dev/null; then
  set -eu
fi

if ! command -v ufw >/dev/null 2>&1; then
  sudo apt update
  sudo apt install -y ufw
fi

sudo ufw default deny incoming
sudo ufw default allow outgoing

# allow SSH so we don't lock ourselves out
sudo ufw allow ssh

# services installed by this installer
sudo ufw allow 1818/tcp    # thermal bridge websocket port
sudo ufw allow 9090/tcp    # cockpit web UI
sudo ufw allow 19999/tcp   # netdata dashboard
sudo ufw allow 21115/tcp   # rustdesk incoming relay
sudo ufw allow 21116/udp

sudo ufw --force enable
sudo ufw status verbose
