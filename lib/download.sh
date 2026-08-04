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
# Download Engine Module
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
# Detect downloader
########################################

detect_downloader() {

    if command_exists curl; then

        DOWNLOADER="curl"

    elif command_exists wget; then

        DOWNLOADER="wget"

    else

        fatal "Neither curl nor wget is installed."

    fi


    info "Using downloader: $DOWNLOADER"

}



########################################
# Check file
########################################

file_exists() {

    [ -f "$1" ]

}



########################################
# Download with curl
########################################

download_curl() {

    local url="$1"
    local output="$2"


    curl \
    -L \
    --fail \
    --retry "$DOWNLOAD_RETRIES" \
    --retry-delay 5 \
    --connect-timeout "$DOWNLOAD_TIMEOUT" \
    -C - \
    -o "$output" \
    "$url"

}



########################################
# Download with wget
########################################

download_wget() {

    local url="$1"
    local output="$2"


    wget \
    --continue \
    --tries="$DOWNLOAD_RETRIES" \
    --timeout="$DOWNLOAD_TIMEOUT" \
    -O "$output" \
    "$url"

}



########################################
# Main download function
########################################

download_file() {


    local url="$1"
    local output="$2"


    section "Downloading File"


    info "URL: $url"

    info "Destination: $output"



    # Skip existing files

    if file_exists "$output"; then

        warning "File already exists"

        return 0

    fi



    mkdir -p "$(dirname "$output")"



    local attempt=1



    while [ $attempt -le "$DOWNLOAD_RETRIES" ]

    do


        info "Download attempt $attempt/$DOWNLOAD_RETRIES"



        if [ "$DOWNLOADER" = "curl" ]; then


            if download_curl "$url" "$output"; then

                success "Download completed"

                return 0

            fi



        else


            if download_wget "$url" "$output"; then

                success "Download completed"

                return 0

            fi


        fi



        warning "Download failed"

        attempt=$((attempt + 1))

        sleep 5


    done



    fatal "Download failed after multiple attempts"

}



########################################
# Verify downloaded file
########################################

verify_download() {


    local file="$1"


    if [ ! -f "$file" ]; then

        error "File not found: $file"

        return 1

    fi



    local size

    size=$(du -h "$file" | awk '{print $1}')



    if [ "$size" = "0" ]; then

        error "Downloaded file is empty"

        return 1

    fi



    success "Verified $file ($size)"

    return 0

}



########################################
# Initialize downloader
########################################

init_downloader() {


    section "Download Engine"


    detect_downloader


    mkdir -p "$TMP_DIR"


    success "Download system ready"

}
