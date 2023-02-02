#!/bin/bash -e

mkdir -p out/
mkdir -p pkg/
wget -nc https://github.com/xiph/opusfile/releases/download/v0.12/opusfile-0.12.tar.gz -O out/opusfile-0.12.tar.gz || true
tar xf out/opusfile-0.12.tar.gz -C pkg/
cd pkg/opusfile-0.12

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
