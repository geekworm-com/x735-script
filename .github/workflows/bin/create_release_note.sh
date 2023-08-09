#!/bin/bash

set -e
set -o pipefail

readonly FILE_NOT_EXIST="152"
readonly INVALID_CLI_ARG_COUNT="154"
readonly INVALID_REQUEST="155"

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

# Check if the artifact path exists
if [ ! -s "$TEMPLATE_FILE_PATH" ]; then
  terminate "Template release note not found or empty: ${TEMPLATE_FILE_PATH}" "${FILE_NOT_EXIST}"
fi

function convert_to_md_line_breaks() {
    local input="$1"
    local output=""
    local IFS=$'\n'

    for line in $input; do
        output="${output}${line}\\n\\n"
    done

    echo "$output"
}

release_data=$(curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "${release_url}")

## check if data are JSON and the response is correct
if ! [[ "$release_data" =~ ^\{.*\}$ ]] || [[ ! $(echo "$release_data" | jq -e --arg RELEASE_ID "$RELEASE_ID" '.id == ($RELEASE_ID|tonumber)') ]]; then
    terminate "The script was not able to pull release data." "${INVALID_REQUEST}"
fi

RELEASE_PUBLICH_DATE=$(echo "$release_data" | jq -r '.published_at')
TAG_NAME=$(echo "$release_data" | jq -r '.tag_name' | sed -n 's/^v//p')

readme_text=$(awk -v tag_name="${TAG_NAME}" -v release_date="$RELEASE_PUBLICH_DATE" -v repo="$GITHUB_REPO" -v msg="$CHANGELOG_MSG" '
    {
    gsub(/##TAG_NAME##/, tag_name);
    gsub(/##RELEASE_DATE##/, release_date);
    gsub(/##REPO##/, repo);
    gsub(/##MSG##/, msg);
    print;
    }
' "$TEMPLATE_FILE_PATH")

release_text=$(convert_to_md_line_breaks "$readme_text")

send_release_note=$(curl -L \
  -X PATCH \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  -w "%{http_code}" \
  -o /dev/null \
  "${release_url}" \
  -d "{\"body\":\"${release_text}\"}")

if [[ "$send_release_note" -ne "200" ]]; then
    terminate "The script was not able to push release note." "${INVALID_REQUEST}"
fi