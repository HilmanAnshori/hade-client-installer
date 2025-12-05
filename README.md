# HaDe Client Installer

This helper package contains the scripts needed to prepare a Ubuntu client for HaDe POS (kiosk) usage.

## Directory layout
- `install.sh`: orchestrates each helper script in order.
- `scripts/01-system-update.sh`: updates/installs core packages.
- `scripts/02-thermal-bridge.sh`: clones the thermal-printer bridge, installs dependencies, and runs it under PM2.
  The script also sets up PM2 to restart the bridge after reboots (`pm2 startup`, `pm2 save`).
- `scripts/03-display-environment.sh`: disables screen lock, sleep, and suppresses GNOME notifications.
- `scripts/04-browser-setup.sh`: removes Firefox, installs Chrome, clears keyrings, and removes extra shortcuts.
- `scripts/05-shortcuts.sh`: copies the HaDe icon, creates `desktop-pos.sh`, and registers the HaDe POS desktop launcher.
- `scripts/06-autostart.sh`: creates `start-pos.sh` and a `.desktop` autostart entry so Chrome kiosk starts on login.

## Usage
1. Grant execute permission: `chmod +x install.sh scripts/*.sh`.
2. Run the installer: `bash install.sh`.
3. Inspect each helper script and remove TODOs (e.g., thermal bridge repo credentials or PM2 config) before running on production machines.  The thermal bridge helper references `Addon Projects/Thermal Print/README.md`; follow that guide for prerequisites such as Bluetooth libraries, udev rules, and printer driver settings.

## Notes
- Each helper script contains inline comments describing additional manual steps (e.g., customizing the bridge URL or Chrome launch arguments).
- The installer assumes you have a working network and sudo privileges.
