#!/bin/bash

# Script 13: Setup Printer dengan setup-printer.sh
# ================================================

set -e

echo ""
echo "========================================="
echo "  [13] Setup Printer Thermal"
echo "========================================="
echo ""

# Check if setup-printer.sh exists
THERMAL_DIR="${HOME}/thermal-printer-bridge"
SETUP_SCRIPT="${THERMAL_DIR}/setup-printer.sh"

if [ ! -f "$SETUP_SCRIPT" ]; then
    echo "⚠️  setup-printer.sh tidak ditemukan di ${THERMAL_DIR}"
    echo "   Pastikan thermal bridge sudah terinstall pada script 02"
    exit 1
fi

echo "ℹ️  Script setup printer ditemukan"
echo "   Path: ${SETUP_SCRIPT}"
echo ""

# Show information
echo "📋 Informasi Setup Printer:"
echo "   - Script ini akan membantu Anda setup printer thermal"
echo "   - Otomatis deteksi printer USB yang terhubung"
echo "   - Generate dan apply udev rules"
echo "   - Simpan konfigurasi ke ~/.hade/thermal-printer-config.sh"
echo ""

# Ask if user wants to setup now
read -rp "Lanjutkan setup printer sekarang? [y/N] " SETUP_CONFIRM
if [[ ! "$SETUP_CONFIRM" =~ ^[Yy]$ ]]; then
    echo ""
    echo "ℹ️  Setup printer dapat dijalankan nanti dengan perintah:"
    echo "   sudo ${SETUP_SCRIPT}"
    echo ""
    exit 0
fi

echo ""
echo "Menjalankan setup printer wizard..."
echo ""

# Run setup printer script with sudo
sudo bash "$SETUP_SCRIPT"

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Setup printer berhasil diselesaikan"
    echo ""
    
    # Check if config was saved
    CONFIG_FILE="${HOME}/.hade/thermal-printer-config.sh"
    if [ -f "$CONFIG_FILE" ]; then
        echo "✓ Konfigurasi tersimpan: ${CONFIG_FILE}"
        echo ""
        echo "📝 Tips berikutnya:"
        echo "   - Thermal bridge akan secara otomatis menggunakan konfigurasi ini"
        echo "   - Untuk memverifikasi: lsusb | grep \$(grep PRINTER_VID ${CONFIG_FILE})"
        echo "   - Jika ada masalah, jalankan: sudo ${SETUP_SCRIPT}"
        echo ""
    fi
else
    echo ""
    echo "⚠️  Setup printer dibatalkan atau gagal"
    echo "   Anda dapat menjalankannya nanti dengan: sudo ${SETUP_SCRIPT}"
    echo ""
fi
