#!/bin/bash

set -e

readonly PACKAGE_PATH="$1"
readonly PACKAGE_VERSION="$2"
declare -a ARCH_LIST=("arm64" "armhf")

# Create the "versions" directory if it doesn't exist
mkdir -p versions

for arch_type in "${ARCH_LIST[@]}"; do
    # Run docker image and build the package in the mounted directory
    docker run --rm -v "$PACKAGE_PATH":/pkg multiarch/debian-debootstrap:"${arch_type}"-bullseye \
    dpkg-deb --build /pkg/x735-script-pkg "versions/x735-script_${PACKAGE_VERSION}_${arch_type}.deb"
done
