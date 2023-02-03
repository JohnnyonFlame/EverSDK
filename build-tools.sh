#!/bin/bash -e
sed -E "s:TOOLCHAIN_PATH:${TOOLCHAIN}:g" templates/meson-cross.ini > ${TOOLCHAIN}/meson-cross.ini
sed -E "s:TOOLCHAIN_PATH:${TOOLCHAIN}:g" templates/armhf.cmake > ${TOOLCHAIN}/armhf.cmake
./toolchain-scripts/pkg-config.sh
