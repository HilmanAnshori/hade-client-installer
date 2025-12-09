#!/bin/bash

# Script: 12-thermal-bridge-auto-update.sh
# Tujuan: Setup auto-update mechanism untuk thermal printer bridge
# Lokasi: Addon Projects/Client Installer/scripts/

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
BRIDGE_DIR="${HOME}/thermal-printer-bridge"
BRIDGE_UPDATE_SCRIPT="${BRIDGE_DIR}/update-bridge.sh"

# Cron schedule: 0 2 * * * = setiap hari jam 2 AM
CRON_SCHEDULE="0 2 * * *"

log_info() {
    echo "[INFO] $1"
}

log_error() {
    echo "[ERROR] $1" >&2
}

# Validasi bridge directory
if [ ! -d "$BRIDGE_DIR" ]; then
    log_error "Bridge directory not found: $BRIDGE_DIR"
    log_error "Pastikan thermal bridge sudah diinstall di $(pwd)/scripts/02-thermal-bridge.sh"
    exit 1
fi

if [ ! -f "$BRIDGE_UPDATE_SCRIPT" ]; then
    log_error "Update script not found: $BRIDGE_UPDATE_SCRIPT"
    exit 1
fi

log_info "Setting up auto-update for thermal bridge..."

# Make update script executable
chmod +x "$BRIDGE_UPDATE_SCRIPT"
log_info "✓ Update script is executable"

# Option 1: Setup systemd timer (recommended for modern Ubuntu)
if command -v systemctl &> /dev/null; then
    log_info "Setting up systemd timer for auto-update (daily at 2 AM)..."
    
    # Copy service & timer files
    SYSTEMD_DIR="/etc/systemd/system"
    if [ -w "$SYSTEMD_DIR" ]; then
        sudo cp "${BRIDGE_DIR}/thermal-bridge-update.service" "$SYSTEMD_DIR/"
        sudo cp "${BRIDGE_DIR}/thermal-bridge-update.timer" "$SYSTEMD_DIR/"
        
        # Enable and start the timer
        sudo systemctl daemon-reload
        sudo systemctl enable thermal-bridge-update.timer
        sudo systemctl start thermal-bridge-update.timer
        
        log_info "✓ Systemd timer installed and started"
        log_info "  Status: sudo systemctl status thermal-bridge-update.timer"
        log_info "  Logs: sudo journalctl -u thermal-bridge-update.service"
    else
        log_error "No write access to $SYSTEMD_DIR. Skipping systemd setup."
    fi
fi

# Option 2: Setup cron job (fallback)
log_info "Setting up cron job for auto-update (daily at 2 AM)..."

CRON_JOB="$CRON_SCHEDULE $BRIDGE_UPDATE_SCRIPT auto >> /tmp/thermal-bridge-update.log 2>&1"

# Check if cron job already exists
if ! (crontab -l 2>/dev/null | grep -F "$BRIDGE_UPDATE_SCRIPT" > /dev/null); then
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    log_info "✓ Cron job installed (daily at 2 AM)"
else
    log_info "ℹ Cron job already exists, skipping"
fi

# Log file for cron updates
touch /tmp/thermal-bridge-update.log
chmod 666 /tmp/thermal-bridge-update.log 2>/dev/null || true
log_info "✓ Log file: /tmp/thermal-bridge-update.log"

log_info ""
log_info "Auto-update setup completed!"
log_info ""
log_info "Manual update commands:"
log_info "  $BRIDGE_UPDATE_SCRIPT           # Update manually anytime"
log_info "  pm2 restart thermal-bridge      # Restart service after manual update"
log_info ""
log_info "Systemd commands:"
log_info "  sudo systemctl status thermal-bridge-update.timer"
log_info "  sudo systemctl stop thermal-bridge-update.timer"
log_info "  sudo systemctl start thermal-bridge-update.timer"
log_info ""
log_info "View logs:"
log_info "  sudo journalctl -u thermal-bridge-update.service -f"
log_info "  tail -f /tmp/thermal-bridge-update.log"
log_info ""
log_info "Check cron job:"
log_info "  crontab -l | grep update-bridge"

