#!/usr/bin/env bash
if ! set -euo pipefail 2>/dev/null; then
  set -eu
fi

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPTS=(
  "scripts/01-system-update.sh"
  "scripts/02-thermal-bridge.sh"
  "scripts/03-display-environment.sh"
  "scripts/04-browser-setup.sh"
  "scripts/05-shortcuts.sh"
  "scripts/06-autostart.sh"
  "scripts/07-install-tailscale.sh"
  "scripts/08-install-cockpit.sh"
  "scripts/09-install-netdata.sh"
  "scripts/10-install-rustdesk.sh"
  "scripts/11-configure-ufw.sh"
)

echo "HaDe Client Installer"
for script in "${SCRIPTS[@]}"; do
  echo
  echo "--- Running ${script} ---"
  bash "$ROOT_DIR/$script"
done


echo
 echo "Client installer completed. Review each step for any TODOs that remain."

read -rp $'Reboot now to apply system changes (thermal bridge, rules, etc.)? [y/N] ' REBOOT_CONFIRM
if [[ "$REBOOT_CONFIRM" =~ ^[Yy]$ ]]; then
  echo "Rebooting now..."
  sudo reboot
else
  echo "Skipping reboot. Please reboot later to ensure services pick up the new configuration."
fi
