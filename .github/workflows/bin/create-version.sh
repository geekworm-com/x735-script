#!/bin/bash

set -e

readonly PACKAGE_PATH="$1"
readonly PACKAGE_VERSION="$2"
declare -a ARCH_LIST=("arm64" "armhf")

mkdir versions

for arch_type in "${ARCH_LIST[@]}"; do
    # run docker image and build the package in the mounted dirctory
    sudo docker run --rm -v $PACKAGE_PATH:/pkg multiarch/debian-debootstrap:${arch_type}-bullseye \
    dpkg-deb --build /pkg/x735-script-pkg versions/x735-script_${PACKAGE_VERSION}_${arch_type}.deb
done




