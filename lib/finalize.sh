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
# Finalization Module
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
# Cleanup temporary files
########################################

cleanup_temp() {


    section "Cleaning Temporary Files"


    if [ -d "$TMP_DIR" ]; then

        rm -rf "$TMP_DIR"

        success "Temporary files removed"

    else

        info "No temporary files found"

    fi

}



########################################
# Generate report
########################################

generate_report() {


    section "Generating Installation Report"


    REPORT="$HOME/android-build-environment-report.txt"


    cat > "$REPORT" <<EOF
========================================
Android Build Environment v2 PRO
Installation Report
========================================

Date:
$(date)

Device:
$(uname -a)

Architecture:
$(uname -m)

Android Home:
$ANDROID_HOME

Java:
$(java -version 2>&1 | head -n 1)

Gradle:
$(gradle -v 2>/dev/null | grep Gradle | head -n 1)

Android API:
$ANDROID_API

Build Tools:
$BUILD_TOOLS

========================================
EOF


    success "Report created:"
    echo "$REPORT"

}



########################################
# Show environment summary
########################################

show_summary() {


    section "Installation Summary"


    echo -e "${CYAN}Android SDK:${NC}"
    echo "$ANDROID_HOME"


    echo


    echo -e "${CYAN}Java:${NC}"

    java -version 2>&1 | head -n 1



    echo


    echo -e "${CYAN}Gradle:${NC}"

    gradle -v 2>/dev/null | grep Gradle | head -n 1



    echo


    echo -e "${CYAN}Android API:${NC}"

    echo "$ANDROID_API"



    echo


    echo -e "${CYAN}Build Tools:${NC}"

    echo "$BUILD_TOOLS"

}



########################################
# Next commands
########################################

show_next_steps() {


    section "Next Steps"


    echo

    echo -e "${GREEN}You can now build Android apps:${NC}"

    echo

    echo "Cordova:"
    echo "  cordova build android"


    echo


    echo "Gradle:"
    echo "  gradle assembleDebug"


    echo


    echo "ADB:"
    echo "  adb devices"


    echo


    echo "Restart Termux:"
    echo "  source ~/.bashrc"


}



########################################
# Final function
########################################

finalize_setup() {


    section "Finalizing Installation"


    cleanup_temp


    generate_report


    show_summary


    show_next_steps



    section "Completed"


    success "Android Build Environment v2 PRO installed successfully"

    echo

    echo -e "${BOLD_GREEN}Anonymat Labs 🚀${NC}"

}
