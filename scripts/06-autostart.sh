#!/usr/bin/env bash
set -euo pipefail

START_SCRIPT="$HOME/start-pos.sh"
cat > "$START_SCRIPT" <<'EOL'
#!/bin/bash
sleep 10
if [ -d "$HOME/.config/google-chrome/Default" ]; then
  sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' "$HOME/.config/google-chrome/Default/Preferences"
fi
/usr/bin/google-chrome --kiosk --kiosk-printing --disable-restore-session-state http://hade-app
EOL
chmod +x "$START_SCRIPT"

AUTOSTART_DIR="$HOME/.config/autostart"
mkdir -p "$AUTOSTART_DIR"
cat > "$AUTOSTART_DIR/startup-hade-pos.desktop" <<'EOL'
[Desktop Entry]
Type=Application
Exec=$START_SCRIPT
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=HaDe POS System
Comment=Auto start HaDe POS
EOL
