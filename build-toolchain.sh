#!/bin/bash -e

./toolchain-scripts/crosstool-ng.sh
./toolchain-scripts/pkg-config.sh
sed -E "s:TOOLCHAIN_PATH:${TOOLCHAIN}:g" templates/meson-cross.ini > ${TOOLCHAIN}/meson-cross.ini
sed -E "s:TOOLCHAIN_PATH:${TOOLCHAIN}:g" templates/armhf.cmake > ${TOOLCHAIN}/armhf.cmake
