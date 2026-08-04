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
# Professional Logger
#

source "$(dirname "$0")/colors.sh"

# Default log file
LOG_FILE="${LOG_FILE:-$HOME/setup.log}"

# Timestamp
timestamp() {
    date "+%Y-%m-%d %H:%M:%S"
}

# Write to log file
write_log() {
    echo "[$(timestamp)] $1" >> "$LOG_FILE"
}

# Section Header
section() {
    echo
    echo -e "${BOLD_CYAN}====================================================${NC}"
    echo -e "${BOLD_WHITE}$1${NC}"
    echo -e "${BOLD_CYAN}====================================================${NC}"
    write_log "SECTION: $1"
}

# Information
info() {
    echo -e "${BLUE}[${INFO}]${NC} $1"
    write_log "[INFO] $1"
}

# Success
success() {
    echo -e "${GREEN}[${CHECK}]${NC} $1"
    write_log "[SUCCESS] $1"
}

# Warning
warning() {
    echo -e "${YELLOW}[${WARN}]${NC} $1"
    write_log "[WARNING] $1"
}

# Error
error() {
    echo -e "${RED}[${CROSS}]${NC} $1"
    write_log "[ERROR] $1"
}

# Fatal Error
fatal() {
    echo -e "${BG_RED}${WHITE} FATAL ${NC} $1"
    write_log "[FATAL] $1"
    exit 1
}

# Divider
divider() {
    echo "----------------------------------------------------"
}

# Blank Line
newline() {
    echo
}
