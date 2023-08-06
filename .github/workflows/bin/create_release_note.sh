#!/bin/bash

readonly INVALID_CLI_ARG_COUNT="154"

terminate() {
    local -r msg=$1
    local -r err_code=${2:-150}
    echo "${msg}" >&2
    exit "${err_code}"
}

if [[ $# -ne 4 ]]; then
    terminate "Usage: $0 TEMPLATE_FILE OUTPUT_FILE TAG_NAME RELEASE_PUBLICH_DATE GITHUB_REPO" "${INVALID_CLI_ARG_COUNT}"
fi

readonly TEMPLATE_FILE_PATH=$1
readonly TAG_NAME=$2
readonly RELEASE_PUBLICH_DATE=$3
readonly GITHUB_REPO=$4

awk -v tag_name="$TAG_NAME" -v release_date="$RELEASE_PUBLICH_DATE" -v repo="$GITHUB_REPO" '
    BEGIN {
        placeholder = 0
    }
    ## {
        for (i = 1; i <= NF; i++) {
            if ($i ~ /##[A-Z_]+##/) {
                sub(/##/, "", $i)
                sub(/##/, "", $i)
                placeholder = 1
            }
            if (placeholder) {
                printf "%s", $i
            } else {
                printf "%s", $i
                if (i < NF) {
                    printf " "
                }
            }
        }
        print ""
        placeholder = 0
    }
    END {
        if (!placeholder) {
            printf "\n"
        }
    }
' "$TEMPLATE_FILE_PATH"
