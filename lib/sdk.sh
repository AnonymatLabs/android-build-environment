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
# Android SDK Installer
#

########################################
# Load dependencies
########################################

SCRIPT_DIR="$(dirname "$0")"

source "$SCRIPT_DIR/../config.sh"
source "$SCRIPT_DIR/colors.sh"
source "$SCRIPT_DIR/logger.sh"
source "$SCRIPT_DIR/download.sh"
source "$SCRIPT_DIR/utils.sh"

########################################
# Create SDK directories
########################################

prepare_sdk_directory() {

    section "Preparing Android SDK Directory"


    mkdir -p "$SDK_ROOT"

    mkdir -p "$CMDLINE_DIR"


    success "SDK directory ready"

}



########################################
# Install Command Line Tools
########################################

install_cmdline_tools() {


    section "Android Command Line Tools"



    if [ -d "$CMDLINE_DIR/latest" ]; then

        success "Command Line Tools already installed"

        return 0

    fi



    local archive="$TMP_DIR/cmdline-tools.zip"


    mkdir -p "$TMP_DIR"



    info "Downloading Android Command Line Tools..."



    download_file \
    "$SDK_URL" \
    "$archive" || fatal "Command Line Tools download failed"



    validate_zip "$archive" || fatal "Invalid SDK archive"



    info "Extracting SDK tools..."



    unzip -q "$archive" -d "$TMP_DIR"



    mkdir -p "$CMDLINE_DIR/latest"



    mv \
    "$TMP_DIR/cmdline-tools"/* \
    "$CMDLINE_DIR/latest/"



    rm -rf "$archive"



    success "Command Line Tools installed"

}



########################################
# Configure sdkmanager
########################################

configure_sdkmanager() {


    section "Configuring SDK Manager"



    export PATH="$CMDLINE_DIR/latest/bin:$PATH"



    if command -v sdkmanager >/dev/null 2>&1; then

        success "sdkmanager detected"

    else

        fatal "sdkmanager not found"

    fi

}



########################################
# Accept licenses
########################################

accept_licenses() {


    section "Accepting Android Licenses"



    yes | sdkmanager --licenses >/dev/null 2>&1



    success "Licenses accepted"

}



########################################
# Install SDK Packages
########################################

install_sdk_packages() {


    section "Installing Android SDK Packages"



    local total=${#SDK_PACKAGES[@]}
    local current=1



    for package in "${SDK_PACKAGES[@]}"
    do


        info "[$current/$total] Installing $package"



        yes | sdkmanager "$package"



        if [ $? -eq 0 ]; then

            success "$package installed"

        else

            fatal "Failed installing $package"

        fi



        current=$((current + 1))


    done


}



########################################
# Verify SDK
########################################

verify_sdk() {


    section "SDK Verification"



    if command -v adb >/dev/null 2>&1; then

        success "ADB available"

    else

        warning "ADB not found in PATH"

    fi



    if command -v aapt2 >/dev/null 2>&1; then

        success "aapt2 available"

    else

        warning "aapt2 not found in PATH"

    fi


}



########################################
# Main SDK Setup
########################################

setup_android_sdk() {


    section "Android SDK Setup"



    prepare_sdk_directory


    install_cmdline_tools


    configure_sdkmanager


    accept_licenses


    install_sdk_packages


    verify_sdk



    success "Android SDK setup completed"

}
