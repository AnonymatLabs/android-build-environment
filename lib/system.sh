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
# System Checks
#

check_termux() {
    [[ -d "/data/data/com.termux/files" ]]
}

check_internet() {
    curl -Is --connect-timeout 5 https://dl.google.com >/dev/null 2>&1
}

check_storage() {
    local free_mb

    free_mb=$(df -Pm "$HOME" | awk 'NR==2 {print $4}')

    [[ "$free_mb" -ge "$MIN_STORAGE_MB" ]]
}

check_architecture() {
    ARCH=$(uname -m)

    case "$ARCH" in
        aarch64|arm64)
            ARCH_NAME="arm64"
            ;;
        armv7l|arm)
            ARCH_NAME="arm"
            ;;
        x86_64)
            ARCH_NAME="x86_64"
            ;;
        *)
            ARCH_NAME="$ARCH"
            ;;
    esac
}

check_android_version() {
    if command -v getprop >/dev/null 2>&1; then
        ANDROID_VERSION=$(getprop ro.build.version.release)
        SDK_LEVEL=$(getprop ro.build.version.sdk)
    else
        ANDROID_VERSION="Unknown"
        SDK_LEVEL="Unknown"
    fi
}

check_java() {
    command -v java >/dev/null 2>&1
}

check_previous_install() {
    [[ -d "$ANDROID_HOME" ]]
}

run_preflight_checks() {

    section "System Check"

    info "Checking Termux..."

    if check_termux; then
        success "Running inside Termux"
    else
        fatal "This installer only supports Termux."
    fi

    info "Checking Internet..."

    if check_internet; then
        success "Internet connection OK"
    else
        fatal "No internet connection."
    fi

    info "Checking Storage..."

    if check_storage; then
        success "Enough storage available"
    else
        fatal "At least ${MIN_STORAGE_MB} MB of free storage is required."
    fi

    info "Detecting Architecture..."

    check_architecture
    success "$ARCH_NAME"

    info "Detecting Android..."

    check_android_version
    success "Android $ANDROID_VERSION (SDK $SDK_LEVEL)"

    info "Checking Java..."

    if check_java; then
        success "Java already installed"
    else
        warning "Java not installed yet"
    fi

    info "Checking previous SDK installation..."

    if check_previous_install; then
        warning "Existing Android SDK detected"
    else
        success "Fresh installation"
    fi
}
