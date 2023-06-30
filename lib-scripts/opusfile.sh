#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/
wget -nc https://github.com/xiph/opusfile/releases/download/v0.12/opusfile-0.12.tar.gz -O dl/opusfile-0.12.tar.gz || true
tar xf dl/opusfile-0.12.tar.gz -C pkg/
cd pkg/opusfile-0.12

export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os -Wno-traditional"
export CXXFLAGS="-Os -Wno-traditional"
export LDFLAGS="-Os -flto"

./configure \
    --prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
    --host="arm-linux-gnueabihf" \
    --enable-static \
    --enable-shared \
    --disable-examples \
    --disable-http

make -j$(($(nproc)+1)) install
