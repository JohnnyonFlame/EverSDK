#!/bin/bash -e
INSTALL_DIR=$(pwd)/out
mkdir -p ${INSTALL_DIR}
mkdir -p dl/
mkdir -p pkg/
wget -nc https://github.com/JohnnyonFlame/android-tools-eversdk/archive/refs/tags/v1.0.tar.gz -O dl/android-tools-eversdk.tar.gz || true
tar xf dl/android-tools-eversdk.tar.gz -C pkg/
cd pkg/android-tools-eversdk-1.0

mkdir -p build-adbd
CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc" \
    make -j$(($(nproc)+1)) SRCDIR=$(pwd) -C $(pwd)/build-adbd -f $(pwd)/debian/makefiles/adbd.mk

cp build-adbd/adbd "${INSTALL_DIR}/adbd"
