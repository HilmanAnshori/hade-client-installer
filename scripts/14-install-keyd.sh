#!/bin/bash
set -euo pipefail

echo "[Keyd] Installing keyd (keyboard remapper) and configuring INSTANT USB Keyboard..."

# Detect sudo availability
SUDO=""
if [[ $EUID -ne 0 ]]; then
  if command -v sudo >/dev/null 2>&1; then
    SUDO="sudo"
  else
    echo "This script requires root privileges (sudo)." >&2
    exit 1
  fi
fi

${SUDO} apt-get update
${SUDO} apt-get install -y git build-essential

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

git clone https://github.com/rvaiya/keyd.git "$tmpdir/keyd"
cd "$tmpdir/keyd"
make
${SUDO} make install

${SUDO} systemctl enable keyd
${SUDO} systemctl restart keyd || ${SUDO} systemctl start keyd

# Write configuration
${SUDO} mkdir -p /etc/keyd
cat <<'EOF' | ${SUDO} tee /etc/keyd/instant-usb.conf >/dev/null
# =======================================================
# Konfigurasi untuk: INSTANT USB Keyboard
# ID Device: 30fa:2031
# =======================================================

[ids]
30fa:2031

[main]
# Backspace menjadi Escape
mail = esc
homepage = A-w
kpminus = A-d
calc = A-r
kpasterisk = A-t
kpslash = layer(slash)
kpplus = A-q

[slash:A]
kp7 = A-1
kp4 = A-2
kp1 = A-3
kp0 = A-4
EOF

${SUDO} systemctl reload keyd || true

echo "[Keyd] Installed and configured at /etc/keyd/instant-usb.conf"
