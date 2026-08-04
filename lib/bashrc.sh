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
# Bash Environment Manager
#

########################################
# Load dependencies
########################################

SCRIPT_DIR="$(dirname "$0")"

source "$SCRIPT_DIR/../config.sh"
source "$SCRIPT_DIR/colors.sh"
source "$SCRIPT_DIR/logger.sh"


BASHRC="$HOME/.bashrc"



########################################
# Backup bashrc
########################################

backup_bashrc() {


    if [ -f "$BASHRC" ]; then


        local backup="$HOME/.bashrc.backup.$(date +%Y%m%d_%H%M%S)"


        cp "$BASHRC" "$backup"


        success "Bashrc backup created"


    fi

}



########################################
# Add line safely
########################################

add_bashrc_line() {


    local line="$1"


    if grep -Fxq "$line" "$BASHRC" 2>/dev/null; then


        warning "Already exists: $line"


    else


        echo "$line" >> "$BASHRC"


        success "Added: $line"


    fi

}



########################################
# Configure Android variables
########################################

configure_android_environment() {


    section "Configuring Environment Variables"



    touch "$BASHRC"



    backup_bashrc



    add_bashrc_line ""

    add_bashrc_line "# Android Build Environment v2 PRO"



    add_bashrc_line "export ANDROID_HOME=$SDK_ROOT"

    add_bashrc_line "export ANDROID_SDK_ROOT=$SDK_ROOT"

    add_bashrc_line "export JAVA_HOME=$PREFIX/opt/openjdk"



    add_bashrc_line "export PATH=\$PATH:\$ANDROID_HOME/cmdline-tools/latest/bin"

    add_bashrc_line "export PATH=\$PATH:\$ANDROID_HOME/platform-tools"

    add_bashrc_line "export PATH=\$PATH:\$ANDROID_HOME/build-tools/$BUILD_TOOLS"



    add_bashrc_line "export PATH=\$PATH:$GRADLE_HOME/bin"



    success "Environment variables configured"

}



########################################
# Reload environment
########################################

reload_environment() {


    section "Reloading Environment"



    if [ -f "$BASHRC" ]; then


        source "$BASHRC"


        success "Environment reloaded"


    else


        warning "No .bashrc found"


    fi

}



########################################
# Verify environment
########################################

verify_environment() {


    section "Environment Verification"



    if [ -n "$ANDROID_HOME" ]; then

        success "ANDROID_HOME=$ANDROID_HOME"

    else

        error "ANDROID_HOME missing"

    fi



    if [ -n "$JAVA_HOME" ]; then

        success "JAVA_HOME=$JAVA_HOME"

    else

        error "JAVA_HOME missing"

    fi



    if echo "$PATH" | grep -q "gradle"; then

        success "Gradle PATH configured"

    else

        warning "Gradle PATH missing"

    fi

}



########################################
# Main function
########################################

setup_environment() {


    section "Environment Setup"



    configure_android_environment


    reload_environment


    verify_environment



    success "Environment configuration completed"

}
