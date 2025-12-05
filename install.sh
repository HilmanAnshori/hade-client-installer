#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPTS=(
  "scripts/01-system-update.sh"
  "scripts/02-thermal-bridge.sh"
  "scripts/03-display-environment.sh"
  "scripts/04-browser-setup.sh"
  "scripts/05-shortcuts.sh"
  "scripts/06-autostart.sh"
)

echo "HaDe Client Installer"
for script in "${SCRIPTS[@]}"; do
  echo
  echo "--- Running ${script} ---"
  bash "$ROOT_DIR/$script"
done

echo
 echo "Client installer completed. Review each step for any TODOs that remain."
