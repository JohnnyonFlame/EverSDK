#!/bin/bash -e

INSTALL_DIR=$(pwd)/out
mkdir -p out/
mkdir -p dl/
mkdir -p pkg/
wget -nc https://libzip.org/download/libzip-1.10.0.tar.xz -O dl/libzip-1.10.0.tar.xz || true
tar xf dl/libzip-1.10.0.tar.xz -C pkg/
cd pkg/libzip-1.10.0

cmake -Bbuild \
    -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN}/armhf.cmake \
    -DCMAKE_BUILD_TYPE=MinSizeRel \
    -DCMAKE_INSTALL_PREFIX="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr"

make -Cbuild -j$(($(nproc)+1)) install
cp "${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr/lib/libzip.so.5.5" ${INSTALL_DIR}/libzip.so.5.5
