#!/data/data/com.termux/files/usr/bin/bash
#
# Android Build Environment v2 PRO
#
# Copyright 2026 Anonymat Labs
#
# Licensed under the Apache License, Version 2.0
#
# You may not use this file except in compliance with the License.
#
# https://www.apache.org/licenses/LICENSE-2.0
#
########################################
# Project Directory
########################################

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"



########################################
# Load Configuration
########################################

source "$ROOT_DIR/config.sh"



########################################
# Load Core Modules
########################################

source "$ROOT_DIR/lib/colors.sh"

source "$ROOT_DIR/lib/logger.sh"

source "$ROOT_DIR/lib/system.sh"

source "$ROOT_DIR/lib/packages.sh"

source "$ROOT_DIR/lib/download.sh"

source "$ROOT_DIR/lib/sdk.sh"

source "$ROOT_DIR/lib/gradle.sh"

source "$ROOT_DIR/lib/bashrc.sh"

source "$ROOT_DIR/lib/verify.sh"

source "$ROOT_DIR/lib/finalize.sh"



########################################
# Banner
########################################

show_banner() {


echo -e "${CYAN}"

cat << "EOF"

    _   _           _           _
   / \ | |_ ___  __| |_ __ ___ (_)
  / _ \| __/ _ \/ _` | '__/ _ \| |
 / ___ \ ||  __/ (_| | | | (_) | |
/_/   \_\__\___|\__,_|_|  \___/|_|


 Android Build Environment
 Version 2 PRO

 Anonymat Labs

EOF

echo -e "${NC}"

}



########################################
# Check root
########################################

check_permissions() {


    if [ "$(id -u)" = "0" ]; then

        warning "Running as root is not recommended in Termux"

    fi

}



########################################
# Main Installation Flow
########################################

main() {


    clear


    show_banner


    check_permissions



    section "Starting Installation"



    info "Version: $APP_VERSION"

    info "Android API: $ANDROID_API"

    info "Gradle: $GRADLE_VERSION"



    run_preflight_checks



    setup_packages



    setup_android_sdk



    setup_gradle



    setup_environment



    run_full_verification



    finalize_setup



}



########################################
# Execute
########################################

main
