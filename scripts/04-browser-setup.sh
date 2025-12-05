#!/usr/bin/env bash
if ! set -euo pipefail 2>/dev/null; then
  set -eu
fi

# Uninstall Firefox (including locale packages) if present
if dpkg -l firefox >/dev/null 2>&1; then
  sudo apt remove --purge -y firefox firefox-locale-* || true
fi
rm -f "$HOME/Desktop/firefox.desktop"
if [ -d "$HOME/.local/share/applications" ]; then
  rm -f "$HOME/.local/share/applications/firefox.desktop"
fi
sudo apt autoremove -y

# Install Google Chrome (stable)
if dpkg -l google-chrome-stable >/dev/null 2>&1; then
  echo "Google Chrome already installed."
else
  CHROME_DEB="$HOME/Downloads/google-chrome-stable_current_amd64.deb"
  if [ ! -f "$CHROME_DEB" ]; then
    wget -O "$CHROME_DEB" https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  fi
  sudo apt install -y "$CHROME_DEB"
  rm -f "$CHROME_DEB"
fi

# Remove Google Chrome desktop shortcuts
rm -f "$HOME/Desktop/google-chrome.desktop"
if [ -d "$HOME/.local/share/applications" ]; then
  rm -f "$HOME/.local/share/applications/google-chrome.desktop"
fi

SYSTEM_CHROME_DESKTOP="/usr/share/applications/google-chrome.desktop"
if [ -f "$SYSTEM_CHROME_DESKTOP" ]; then
  if grep -q '^NoDisplay=' "$SYSTEM_CHROME_DESKTOP"; then
    sudo sed -i 's/^NoDisplay=.*/NoDisplay=true/' "$SYSTEM_CHROME_DESKTOP"
  else
    sudo bash -c 'printf "\nNoDisplay=true\n" >> '"$SYSTEM_CHROME_DESKTOP"
  fi
fi

# Clear GNOME keyrings for default password store
rm -f "$HOME/.local/share/keyrings"/*.keyring || true
