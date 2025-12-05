#!/usr/bin/env bash
set -euo pipefail

# Remove Firefox if installed
if dpkg -l firefox >/dev/null 2>&1; then
  sudo apt remove --purge -y firefox
fi
sudo apt autoremove -y

# Install Google Chrome (stable)
CHROME_DEB="$HOME/Downloads/google-chrome-stable_current_amd64.deb"
if [ ! -f "$CHROME_DEB" ]; then
  wget -O "$CHROME_DEB" https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
fi
sudo apt install -y "$CHROME_DEB"
rm -f "$CHROME_DEB"

# Remove desktop shortcut and pin
rm -f "$HOME/Desktop/google-chrome.desktop"
if [ -d "$HOME/.local/share/applications" ]; then
  rm -f "$HOME/.local/share/applications/google-chrome.desktop"
fi

# Clear GNOME keyrings for default password store
rm -f "$HOME/.local/share/keyrings"/*.keyring || true
