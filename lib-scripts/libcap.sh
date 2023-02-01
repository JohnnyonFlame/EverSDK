#!/bin/bash -e

mkdir -p out/
mkdir -p pkg/
wget -nc https://git.kernel.org/pub/scm/libs/libcap/libcap.git/snapshot/libcap-2.49.tar.gz -O out/libcap-2.49.tar.gz || true
tar xf out/libcap-2.49.tar.gz -C pkg/
cd pkg/libcap-2.49

export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-O2"
export CXXFLAGS="-O2"

make -C libcap \
    BUILD_CC=gcc \
    COPTS="${CFLAGS}" \
    CROSS_COMPILE="${TOOLCHAIN}/bin/arm-linux-gnueabihf-" \
    SHARED=no \
    lib=lib \
    prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
    -j$(($(nproc) + 1)) install

make -C libcap \
    BUILD_CC=gcc \
    COPTS="${CFLAGS}" \
    CROSS_COMPILE="${TOOLCHAIN}/bin/arm-linux-gnueabihf-" \
    SHARED=yes \
    lib=lib \
    prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
    -j$(($(nproc) + 1)) install
