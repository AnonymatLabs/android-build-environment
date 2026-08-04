#!/data/data/com.termux/files/usr/bin/bash
#
# Android Build Environment v2 PRO
# One Command Installer
#
# Copyright 2026 Anonymat Labs
#

set -e


REPO="https://github.com/AnonymatLabs/android-build-v2-pro.git"

INSTALL_DIR="$HOME/android-build-v2-pro"


echo "
========================================
 Android Build Environment v2 PRO
 One Command Installer

 Anonymat Labs
========================================
"


# Check git

if ! command -v git >/dev/null 2>&1; then

    echo "[+] Installing git..."

    pkg update -y
    pkg install git -y

fi



# Clone repository

if [ ! -d "$INSTALL_DIR" ]; then

    echo "[+] Downloading installer..."

    git clone "$REPO" "$INSTALL_DIR"

else

    echo "[i] Existing installation detected"

fi



cd "$INSTALL_DIR"



chmod +x setup.sh



echo "[+] Starting setup..."

./setup.sh
