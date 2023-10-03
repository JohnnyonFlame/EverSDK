#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/
wget -nc https://github.com/xiph/opus/releases/download/v1.1.2/opus-1.1.2.tar.gz -O dl/opus-1.1.2.tar.gz || true
tar xf dl/opus-1.1.2.tar.gz -C pkg/
cd pkg/opus-1.1.2

export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os -ffunction-sections -fdata-sections -Wno-traditional"
export CXXFLAGS="-Os -ffunction-sections -fdata-sections -Wno-traditional"
export LDFLAGS="-Os -flto"

./configure \
    --prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
    --host="arm-linux-gnueabihf" \
    --enable-static \
    --enable-shared \
    --disable-examples \
    --disable-http

make -j$(($(nproc)+1)) install
