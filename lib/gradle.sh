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
# Gradle Installer Module
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
# Prepare Gradle directory
########################################

prepare_gradle_directory() {

    section "Preparing Gradle Directory"


    mkdir -p "$GRADLE_HOME"

    mkdir -p "$TMP_DIR"


    success "Gradle directory ready"

}



########################################
# Check existing Gradle
########################################

check_gradle() {

    if command -v gradle >/dev/null 2>&1; then

        GRADLE_INSTALLED=$(gradle -v 2>/dev/null | grep "Gradle" | head -n 1)

        success "Gradle already installed"

        info "$GRADLE_INSTALLED"

        return 0

    fi


    return 1

}



########################################
# Download Gradle
########################################

download_gradle() {


    section "Downloading Gradle"



    local archive="$TMP_DIR/gradle-${GRADLE_VERSION}-bin.zip"



    if [ -f "$archive" ]; then

        warning "Gradle archive already exists"

        return 0

    fi



    info "Downloading Gradle $GRADLE_VERSION"



    download_file \
    "$GRADLE_URL" \
    "$archive" || fatal "Gradle download failed"



    validate_zip "$archive" || fatal "Invalid Gradle archive"



    success "Gradle download completed"

}



########################################
# Extract Gradle
########################################

extract_gradle() {


    section "Extracting Gradle"



    local archive="$TMP_DIR/gradle-${GRADLE_VERSION}-bin.zip"



    if [ -d "$GRADLE_HOME/bin" ]; then

        warning "Gradle already extracted"

        return 0

    fi



    unzip -q "$archive" -d "$SDK_ROOT"



    if [ -d "$SDK_ROOT/gradle-${GRADLE_VERSION}" ]; then


        mv \
        "$SDK_ROOT/gradle-${GRADLE_VERSION}" \
        "$GRADLE_HOME"


    else

        fatal "Gradle extraction failed"

    fi



    success "Gradle extracted"

}



########################################
# Configure Gradle PATH
########################################

configure_gradle() {


    section "Configuring Gradle"



    export PATH="$GRADLE_HOME/bin:$PATH"



    if command -v gradle >/dev/null 2>&1; then

        success "Gradle available in PATH"

    else

        fatal "Gradle command not found"

    fi

}



########################################
# Verify Gradle
########################################

verify_gradle() {


    section "Gradle Verification"



    if gradle -v >/dev/null 2>&1; then


        VERSION=$(gradle -v | grep "Gradle" | head -n 1)


        success "$VERSION"


    else


        fatal "Gradle verification failed"


    fi

}



########################################
# Main Gradle Setup
########################################

setup_gradle() {


    section "Gradle Setup"



    if check_gradle; then

        return 0

    fi



    prepare_gradle_directory


    download_gradle


    extract_gradle


    configure_gradle


    verify_gradle



    success "Gradle setup completed"

}
