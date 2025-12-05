#!/usr/bin/env bash
if ! set -euo pipefail 2>/dev/null; then
  set -eu
fi

# Install Node.js (or use existing toolchain)
if ! command -v node >/dev/null 2>&1; then
  curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
  sudo apt install -y nodejs
fi

package_available() {
  apt-cache show "$1" >/dev/null 2>&1
}

install_python_distutils() {
  for candidate in python3-distutils python3.12-distutils python3.11-distutils python3.10-distutils python3.9-distutils python3.8-distutils; do
    if package_available "$candidate"; then
      if sudo apt install -y "$candidate"; then
        return 0
      fi
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

pm2 delete hale-thermal-bridge >/dev/null 2>&1 || true
pm2 start npm --name hale-thermal-bridge -- start
pm2 save

echo "Configure PM2 to launch on boot"
sudo pm2 startup systemd -u "$USER" --hp "$HOME"
pm2 save
cat <<'EOF'
Review ${BRIDGE_DIR}/README.md in the Thermal Print addon for Bluetooth and udev requirements before handling printers.
EOF
