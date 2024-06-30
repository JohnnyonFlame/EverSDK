#!/bin/bash -e

INSTALL_DIR=$(pwd)/out
mkdir -p out/
mkdir -p dl/
mkdir -p pkg/
wget -nc https://download.sourceforge.net/libpng/libpng-1.6.43.tar.gz -O dl/libpng-1.6.43.tar.gz || true
tar xf dl/libpng-1.6.43.tar.gz -C pkg/
cd pkg/libpng-1.6.43

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
    --enable-shared

make clean
make -j$(($(nproc)+1)) install

