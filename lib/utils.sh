#!/data/data/com.termux/files/usr/bin/bash
#
# Android Build Environment v2 PRO
# Utility Functions
#
# Copyright 2026 Anonymat Labs
#
# Licensed under the Apache License, Version 2.0
#

########################################
# Command checker
########################################

command_exists() {

    command -v "$1" >/dev/null 2>&1

}



########################################
# Directory creation
########################################

create_directory() {

    local dir="$1"


    if [ ! -d "$dir" ]; then

        mkdir -p "$dir"

    fi

}



########################################
# Check file exists
########################################

file_exists() {

    local file="$1"


    [ -f "$file" ]

}



########################################
# Check directory exists
########################################

directory_exists() {

    local dir="$1"


    [ -d "$dir" ]

}



########################################
# Get architecture
########################################

get_architecture() {

    uname -m

}



########################################
# Get available storage
########################################

get_available_storage() {


    df -h "$HOME" | awk 'NR==2 {print $4}'


}



########################################
# Check internet connection
########################################

check_internet() {


    if command_exists curl; then


        curl -Is https://google.com >/dev/null 2>&1


    elif command_exists wget; then


        wget -q --spider https://google.com


    else


        return 1


    fi

}



########################################
# Ask user confirmation
########################################

confirm() {


    local message="$1"


    read -p "$message [y/N]: " answer


    case "$answer" in

        y|Y|yes|YES)

            return 0
            ;;


        *)

            return 1
            ;;

    esac

}



########################################
# Backup file
########################################

backup_file() {


    local file="$1"


    if [ -f "$file" ]; then


        cp "$file" "${file}.backup.$(date +%Y%m%d_%H%M%S)"


    fi

}



########################################
# Add line to file safely
########################################

add_line_if_missing() {


    local line="$1"
    local file="$2"


    touch "$file"


    if ! grep -Fxq "$line" "$file"; then


        echo "$line" >> "$file"


    fi

}



########################################
# Detect CPU cores
########################################

get_cpu_cores() {


    nproc 2>/dev/null || echo "1"

}



########################################
# Compare versions
########################################

version_compare() {


    printf '%s\n%s\n' "$1" "$2" | sort -V | head -n1

}



########################################
# Cleanup function
########################################

cleanup_file() {


    local file="$1"


    if [ -e "$file" ]; then


        rm -rf "$file"


    fi

}



########################################
# Export utilities
########################################

export -f command_exists
export -f create_directory
export -f file_exists
export -f directory_exists
export -f get_architecture
export -f get_available_storage
export -f check_internet
export -f confirm
export -f backup_file
export -f add_line_if_missing
export -f get_cpu_cores
export -f version_compare
export -f cleanup_file
