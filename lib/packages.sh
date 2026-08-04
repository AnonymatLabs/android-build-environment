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
# Package Manager Module
#

########################################
# Load dependencies
########################################

SCRIPT_DIR="$(dirname "$0")"

source "$SCRIPT_DIR/../config.sh"
source "$SCRIPT_DIR/colors.sh"
source "$SCRIPT_DIR/logger.sh"
source "$SCRIPT_DIR/utils.sh"

########################################
# Check command existence
########################################

command_exists() {
    command -v "$1" >/dev/null 2>&1
}


########################################
# Install single package
########################################

install_package() {

    local package="$1"
    local retries=3
    local attempt=1


    # Check if already installed
    if command_exists "$package"; then
        success "$package already installed"
        return 0
    fi


    info "Installing $package..."


    while [ $attempt -le $retries ]
    do

        if pkg install -y "$package"; then

            success "$package installed successfully"
            return 0

        fi


        warning "Failed installing $package (attempt $attempt/$retries)"

        attempt=$((attempt + 1))

        sleep 3

    done


    error "Could not install $package"

    return 1
}



########################################
# Install OpenJDK 21
########################################

install_java() {


    section "Java Setup"


    if command_exists java; then

        JAVA_VERSION=$(java -version 2>&1 | head -n 1)

        success "Java already installed"
        info "$JAVA_VERSION"

        return 0
    fi


    info "Installing OpenJDK 21..."


    if pkg install -y openjdk-21; then

        success "OpenJDK 21 installed"

    else

        fatal "OpenJDK 21 installation failed"

    fi


    if command_exists java; then

        success "Java verification successful"

    else

        fatal "Java command not found after installation"

    fi

}



########################################
# Update Termux packages
########################################

update_packages() {


    section "Updating Termux Packages"


    info "Updating package database..."

    pkg update -y || fatal "pkg update failed"


    info "Upgrading installed packages..."

    pkg upgrade -y || warning "Some packages could not upgrade"


    success "Termux packages updated"

}



########################################
# Install required packages
########################################

install_required_packages() {


    section "Installing Required Packages"


    local total=${#PACKAGES[@]}
    local current=1


    for package in "${PACKAGES[@]}"
    do

        divider

        info "[$current/$total] Checking $package"


        if install_package "$package"; then

            :

        else

            fatal "Stopping because $package failed"

        fi


        current=$((current + 1))

    done


    success "Basic packages installed"

}



########################################
# Verify packages
########################################

verify_packages() {


    section "Package Verification"


    local commands=(
        wget
        curl
        git
        zip
        unzip
        tar
        which
    )


    for cmd in "${commands[@]}"
    do

        if command_exists "$cmd"; then

            success "$cmd OK"

        else

            error "$cmd missing"

        fi

    done



    if command_exists java; then

        success "Java OK"

    else

        error "Java missing"

    fi

}



########################################
# Main package setup
########################################

setup_packages() {


    section "Package Installation"


    update_packages


    install_required_packages


    install_java


    verify_packages


    success "Package setup completed"

}
