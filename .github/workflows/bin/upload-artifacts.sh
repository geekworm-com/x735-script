#!/bin/bash

set -e

# Function to upload an artifact to the release
upload_artifact() {
  local artifact_path=$1
  local upload_url=$2
  local token=$3

  filename=$(basename "$artifact_path")
  echo "Uploading $filename..."
  curl \
    -X POST \
    --data-binary @"$artifact_path" \
    -H "Authorization: Bearer $token" \
    -H "Content-Type: application/octet-stream" \
    "$upload_url?name=$filename"
}

# Main script starts here
if [ $# -lt 3 ]; then
  echo "Usage: $0 <artifact_path> <upload_url> <token>"
  exit 1
fi

artifact_path=$1
upload_url=$2
token=$3

# Check if the artifact path exists
if [ ! -f "$artifact_path" ]; then
  echo "Artifact file not found: $artifact_path"
  exit 1
fi

upload_artifact "$artifact_path" "$upload_url" "$token"
