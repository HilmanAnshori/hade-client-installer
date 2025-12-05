#!/usr/bin/env bash
if ! set -euo pipefail 2>/dev/null; then
  set -eu
fi
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl gnupg software-properties-common openssh-server

# Remove Firefox early if present so it does not interfere with kiosk setup.
if dpkg -l firefox >/dev/null 2>&1; then
  sudo apt remove --purge -y firefox firefox-locale-* || true
fi
