#!/usr/bin/env bash
if ! set -euo pipefail 2>/dev/null; then
  set -eu
fi

ICON_SRC="$PWD/hade-icon.png"
ICON_DST="/usr/share/pixmaps/hade-icon.png"
if [ -f "$ICON_SRC" ]; then
  sudo cp "$ICON_SRC" "$ICON_DST"
fi

DESKTOP_SCRIPT="$HOME/desktop-pos.sh"
cat > "$DESKTOP_SCRIPT" <<'EOL'
#!/bin/bash
if [ -d "$HOME/.config/google-chrome/Default" ]; then
  sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' "$HOME/.config/google-chrome/Default/Preferences"
fi
/usr/bin/google-chrome --kiosk --kiosk-printing --disable-restore-session-state http://hade.system
EOL
chmod +x "$DESKTOP_SCRIPT"

APP_DIR="$HOME/.local/share/applications"
mkdir -p "$APP_DIR"
cat > "$APP_DIR/hade-pos.desktop" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=HaDe POS System
Comment=Masuk ke Mode Kasir (Kiosk)
Exec=$DESKTOP_SCRIPT
Icon=$ICON_DST
Terminal=false
Categories=Utility;Network;WebBrowser;
StartupNotify=false
EOF

update-desktop-database "$APP_DIR"
