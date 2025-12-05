#!/usr/bin/env bash
set -euo pipefail

# Disable screen lock and sleep
gsettings set org.gnome.desktop.session idle-delay 0 || true
gsettings set org.gnome.desktop.screensaver lock-delay 0 || true
gsettings set org.gnome.desktop.screensaver lock-enabled false || true
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing' || true

# Silence notifications
gsettings set org.gnome.desktop.notifications show-banners false || true
 