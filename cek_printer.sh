#!/bin/bash

echo "=========================================="
echo "   🔍  ALAT PENCARI PRINTER USB LINUX    "
echo "=========================================="
echo ""

# 1. Cek berdasarkan USB Class (Cara Paling Akurat)
# Printer asli biasanya punya Class=07
echo "[1] Mencari perangkat dengan Class=07 (Standar Printer)..."
if command -v usb-devices &> /dev/null; then
    usb-devices | awk '
        /T:/ { id = $0 }
        /S:[[:space:]]+Manufacturer=/ { mfr = $0 }
        /S:[[:space:]]+Product=/ { prod = $0 }
        /C:.* 07/ {
            print "✅ DITEMUKAN (Via Class):"
            if (id) { print id }
            if (mfr) { print mfr }
            if (prod) { print prod }
            print "----------------"
            id = mfr = prod = ""
        }
    '
else
    echo "❌ Perintah 'usb-devices' tidak ditemukan. Lewati."
fi

echo ""

# 2. Cek berdasarkan Keyword Nama di LSUSB
echo "[2] Mencari berdasarkan Nama di lsusb..."
lsusb | grep -iE --color=always "print|pos|thermal|receipt|winbond|0416"

if [ $? -ne 0 ]; then
    echo "⚠️ Tidak ada nama umum printer yang terdeteksi di lsusb."
else
    echo "👉 Perangkat di atas kemungkinan adalah printer Anda."
fi

echo ""

# 3. Cek apakah Kernel mendeteksi
echo "[3] Cek Log Kernel (dmesg) untuk 'usblp'..."
dmesg | grep -i "usblp" | tail -n 5

echo ""
echo "=========================================="
