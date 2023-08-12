#!/bin/bash

set -e

readonly FILE_NOT_EXIST="152"
readonly INVALID_CLI_ARG_COUNT="154"

terminate() {
    local -r msg=$1
    local -r err_code=${2:-150}
    echo "${msg}" >&2
    exit "${err_code}"
}

# Function to upload an artifact to the release
upload_artifact() {
  local artifact_path=$1
  local upload_url=$2
  local token=$3

  filename=$(basename "$artifact_path")
  echo "Uploading $filename..."

    curl -L \
    -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${token}" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    -H "Content-Type: application/octet-stream" \
    "$upload_url=$filename" \
    --data-binary "@${artifact_path}"
}

# Main script starts here
if [ $# -lt 3 ]; then
  terminate "Usage: $0 <artifact_path> <upload_url> <token>" "${INVALID_CLI_ARG_COUNT}"
fi

artifact_path=$1
upload_url=$2
token=$3

# Check if the artifact path exists
if [ ! -f "$artifact_path" ]; then
  terminate "Artifact file not found: ${artifact_path}" "${FILE_NOT_EXIST}"
fi

upload_artifact "$artifact_path" "$upload_url" "$token"
