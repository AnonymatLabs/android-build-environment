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
# Verification Engine
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
# Check command
########################################

verify_command() {

    local cmd="$1"
    local name="$2"


    if command -v "$cmd" >/dev/null 2>&1; then

        success "$name detected"

        return 0

    else

        error "$name missing"

        return 1

    fi

}



########################################
# Java verification
########################################

verify_java() {


    section "Java Verification"


    if command -v java >/dev/null 2>&1; then


        JAVA_VERSION=$(java -version 2>&1 | head -n 1)


        success "$JAVA_VERSION"


    else


        error "Java not installed"


    fi


}



########################################
# Gradle verification
########################################

verify_gradle() {


    section "Gradle Verification"



    if command -v gradle >/dev/null 2>&1; then


        VERSION=$(gradle -v 2>/dev/null | grep "Gradle" | head -n 1)


        success "$VERSION"


    else


        error "Gradle missing"


    fi

}



########################################
# Android SDK verification
########################################

verify_android_sdk() {


    section "Android SDK Verification"



    if [ -d "$ANDROID_HOME" ]; then


        success "Android SDK found"


    else


        error "Android SDK directory missing"


    fi



    verify_command "sdkmanager" "SDK Manager"

    verify_command "adb" "ADB"


}



########################################
# Build Tools verification
########################################

verify_build_tools() {


    section "Build Tools Verification"



    local BUILD_DIR="$ANDROID_HOME/build-tools/$BUILD_TOOLS"



    if [ -d "$BUILD_DIR" ]; then


        success "Build Tools $BUILD_TOOLS installed"


    else


        error "Build Tools missing"


    fi



    verify_command "aapt2" "AAPT2"

    verify_command "zipalign" "Zipalign"

    verify_command "apksigner" "APK Signer"


}



########################################
# Platform verification
########################################

verify_platform() {


    section "Android Platform Verification"



    local PLATFORM="$ANDROID_HOME/platforms/android-$ANDROID_API"



    if [ -d "$PLATFORM" ]; then


        success "Android API $ANDROID_API installed"


    else


        error "Android API $ANDROID_API missing"


    fi


}



########################################
# Environment verification
########################################

verify_environment_variables() {


    section "Environment Variables"



    if [ -n "$ANDROID_HOME" ]; then

        success "ANDROID_HOME=$ANDROID_HOME"

    else

        error "ANDROID_HOME missing"

    fi



    if [ -n "$JAVA_HOME" ]; then

        success "JAVA_HOME=$JAVA_HOME"

    else

        warning "JAVA_HOME missing"

    fi


}



########################################
# Full verification
########################################

run_full_verification() {


    section "Android Build Environment v2 PRO Diagnostics"



    verify_environment_variables


    verify_java


    verify_gradle


    verify_android_sdk


    verify_build_tools


    verify_platform



    section "Verification Finished"



    success "Diagnostic process completed"

}
