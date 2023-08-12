#!/bin/bash

set -e

readonly CHANGELOG_PATH="$1"
readonly CHANGELOG_MSG="$2"
readonly VERSION="$3"

readonly INVALID_CLI_ARG_COUNT="154"

terminate() {
    local -r msg=$1
    local -r err_code=${2:-150}
    echo "${msg}" >&2
    exit "${err_code}"
}

# Check if commit message is not empty
if [ ! -n "$CHANGELOG_MSG" ]; then
    terminate "Error: No commit message found in the trigger commit." "${INVALID_CLI_ARG_COUNT}"
fi

# Function to check if DEBIAN/changelog file exists
changelog_exists() {
    [ -e "${CHANGELOG_PATH}" ]
}

# Function to create or append to DEBIAN/changelog
create_or_append_changelog() {
    local message=$1

    if changelog_exists; then
        dch --package x735-script --newversion "${VERSION}" --changelog "${CHANGELOG_PATH}" -- "$message [v${VERSION}]"
    else
        dch --package x735-script --newversion "${VERSION}" --create --changelog "${CHANGELOG_PATH}" -- "Initial Release. [v${VERSION}]"
    fi
}

# Main script
create_or_append_changelog "$CHANGELOG_MSG"