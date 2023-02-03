#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/
wget -nc https://github.com/xiph/ogg/releases/download/v1.3.5/libogg-1.3.5.tar.gz -O dl/libogg-1.3.5.tar.gz || true
tar xf dl/libogg-1.3.5.tar.gz -C pkg/
cd pkg/libogg-1.3.5

export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-O2 -Wno-traditional"
export CXXFLAGS="-O2 -Wno-traditional"

./configure \
    --prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
    --host="arm-linux-gnueabihf" \
    --enable-static \
    --enable-shared \
    --disable-examples \
    --disable-http

make -j$(($(nproc)+1)) install
