# HaDe Client Installer

This helper package contains the scripts needed to prepare a Ubuntu client for HaDe POS (kiosk) usage.

## Setup from scratch
```bash
sudo apt update
sudo apt install -y git
if [ -d hade-client-installer ]; then
  rm -rf hade-client-installer
fi
git clone https://github.com/HilmanAnshori/hade-client-installer.git
cd hade-client-installer
chmod +x install.sh scripts/*.sh
bash install.sh
```

> Jalankan setiap baris secara berurutan agar installer dapat mempersiapkan Ubuntu client berikut semua helper scriptnya.

## Directory layout
- `install.sh`: orchestrates each helper script in order and prompts for a reboot at the end.
- `scripts/01-system-update.sh`: updates/installs core packages.
- `scripts/02-thermal-bridge.sh`: clones the thermal-printer bridge, installs dependencies, runs it under PM2, and installs the UDEV rule from the bridge repo.
- `scripts/03-display-environment.sh`: disables screen lock, sleep, and suppresses GNOME notifications.
- `scripts/04-browser-setup.sh`: removes Firefox, installs Chrome, cleans up shortcuts, and resets Chrome state prior to kiosk launch.
- `scripts/05-shortcuts.sh`: copies the HaDe icon, creates `desktop-pos.sh`, and registers the HaDe POS desktop launcher.
- `scripts/06-autostart.sh`: creates `start-pos.sh` and a `.desktop` autostart entry so Chrome kiosk starts on login every boot.
- `scripts/07-install-tailscale.sh`: installs Tailscale if missing and enables `tailscaled`.
- `scripts/08-install-cockpit.sh`: installs Cockpit for remote system administration and enables `cockpit.socket`.
- `scripts/09-install-netdata.sh`: installs Netdata, binds it to `localhost`, and starts the monitoring agent.
- `scripts/10-install-rustdesk.sh`: downloads the latest RustDesk `.deb` release, installs it, and leaves it available in the desktop menu.

## Usage
1. Grant execute permission: `chmod +x install.sh scripts/*.sh`.
2. Run the installer: `bash install.sh`.
3. Follow the prompts (including the reboot confirmation at the end) before using the kiosk.
4. Inspect each helper script and remove TODOs (e.g., thermal bridge repo credentials or PM2 config) before running on production machines.  The thermal bridge helper references `Addon Projects/Thermal Print/README.md`; follow that guide for prerequisites such as Bluetooth libraries, udev rules, and printer driver settings.

## Notes
- Each helper script contains inline comments describing additional manual steps (e.g., customizing the bridge URL or Chrome launch arguments).
- The installer assumes you have a working network and sudo privileges.
