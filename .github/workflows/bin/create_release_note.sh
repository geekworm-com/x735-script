#!/bin/bash

set -e
set -o pipefail

readonly INVALID_CLI_ARG_COUNT="154"

terminate() {
    local -r msg=$1
    local -r err_code=${2:-150}
    echo "${msg}" >&2
    exit "${err_code}"
}

if [[ $# -ne 5 ]]; then
    terminate "Usage: $0 TEMPLATE_FILE GITHUB_REPO TOKEN RELEASE_ID CHANGELOG_MSG" "${INVALID_CLI_ARG_COUNT}"
fi

readonly TEMPLATE_FILE_PATH=$1
readonly GITHUB_REPO=$2
readonly TOKEN=$3
readonly RELEASE_ID=$4
readonly CHANGELOG_MSG=$5

readonly release_url="https://api.github.com/repos/${GITHUB_REPO}/releases/${RELEASE_ID}"

release_data=$(curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "${release_url}")

RELEASE_PUBLICH_DATE=$(echo "$release_data" | jq -r '.published_at')
TAG_NAME=$(echo "$release_data" | jq -r '.tag_name' | sed -n 's/^v//p')

release_note_text=$(awk -v tag_name="${TAG_NAME}" -v release_date="$RELEASE_PUBLICH_DATE" -v repo="$GITHUB_REPO" -v msg="$CHANGELOG_MSG" '
    {
    gsub(/##TAG_NAME##/, tag_name);
    gsub(/##RELEASE_DATE##/, release_date);
    gsub(/##REPO##/, repo);
    gsub(/##MSG##/, msg);
    print;
    }
' "$TEMPLATE_FILE_PATH")

curl -L \
  -X PATCH \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "${release_url}" \
  -d "{\"body\":\"${release_note_text}\""