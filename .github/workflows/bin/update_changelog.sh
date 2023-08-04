#!/bin/bash

set -e

readonly PACKAGE_PATH="$1"
readonly CHANGELOG_MSG="$2"

readonly CHANGELOG_FILE_PATH="${PACKAGE_PATH}/DEBIAN/changelog"

readonly PERMISSION_DENIED="151"
readonly FILE_NOT_EXIST="152"
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
    [ -e "${CHANGELOG_FILE_PATH}" ]
}

# Function to create or append to DEBIAN/changelog
create_or_append_changelog() {
    local message=$1

    if changelog_exists; then
        dch --append --changelog "${CHANGELOG_FILE_PATH}" -- "$message"
    else
        dch --create --changelog "${CHANGELOG_FILE_PATH}" -- "Initial Release."
    fi
}

# Main script
create_or_append_changelog "$CHANGELOG_MSG"
echo "Changelog updated with the commit message: $CHANGELOG_MSG"