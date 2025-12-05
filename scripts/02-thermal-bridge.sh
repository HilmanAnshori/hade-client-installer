#!/usr/bin/env bash
set -euo pipefail

# Install Node.js (or use existing toolchain)
if ! command -v node >/dev/null 2>&1; then
  curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
  sudo apt install -y nodejs
fi

install_python_distutils() {
  if sudo apt install -y python3-distutils; then
    return 0
  fi

  for candidate in python3.11-distutils python3.10-distutils python3.9-distutils; do
    if sudo apt install -y "$candidate"; then
      return 0
    fi
  done

  echo "Warning: no python3 distutils package is available in apt; some Python tooling may not work."
}

BRIDGE_DIR="$HOME/thermal-printer-bridge"
if [ ! -d "$BRIDGE_DIR" ]; then
  echo "Cloning thermal-printer-bridge..."
  git clone https://github.com/HilmanAnshori/thermal-printer-bridge "$BRIDGE_DIR"
fi

RULE_FILE="${THERMAL_PRINT_RULES:-$BRIDGE_DIR/99-thermal-printer.rules}"

cd "$BRIDGE_DIR"
if [ -f config.example.json ] && [ ! -f config.json ]; then
  echo "Copying default config.example.json to config.json..."
  cp config.example.json config.json
fi
npm install

if ! command -v pm2 >/dev/null 2>&1; then
  sudo npm install -g pm2
fi

sudo apt install -y sqlite3 libbluetooth-dev build-essential || true
install_python_distutils

if [ -f "$RULE_FILE" ]; then
  echo "Installing thermal printer udev rule..."
  sudo cp "$RULE_FILE" /etc/udev/rules.d/
  sudo udevadm control --reload-rules
  sudo udevadm trigger
  sudo usermod -a -G dialout "$USER"
  sudo systemctl restart udev
else
  echo "Warning: $RULE_FILE missing; skipping udev rule installation."
fi

pm2 start npm --name hale-thermal-bridge -- start
pm2 save

echo "Configure PM2 to launch on boot"
sudo pm2 startup systemd -u "$USER" --hp "$HOME"
pm2 save
cat <<'EOF'
Review ${BRIDGE_DIR}/README.md in the Thermal Print addon for Bluetooth and udev requirements before handling printers.
EOF
