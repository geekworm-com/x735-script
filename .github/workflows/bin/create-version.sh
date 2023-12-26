#!/bin/bash

set -e

readonly PACKAGE_PATH="$1"
readonly CONTROL_PATH="$2"
readonly PACKAGE_VERSION="$3"
declare -a ARCH_LIST=("arm64" "armhf")

# Create the "versions" directory if it doesn't exist
mkdir -p ${PACKAGE_PATH}/versions

for arch_type in "${ARCH_LIST[@]}"; do
    # first change the Architecture in the DEBIAN/control file
    sed -i "/^Architecture:.*/ c Architecture: ${arch_type}" "${CONTROL_PATH}"

    # Run docker image and build the package in the mounted directory
    docker run --rm -v "$PACKAGE_PATH":/pkg multiarch/debian-debootstrap:"${arch_type}"-bullseye \
    dpkg-deb --build /pkg/x735-script-pkg "/pkg/versions/x735-script_${PACKAGE_VERSION}_${arch_type}.deb"
done
