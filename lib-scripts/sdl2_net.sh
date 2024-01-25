#!/bin/bash -e

INSTALL_DIR=$(pwd)/out
mkdir -p dl/
mkdir -p pkg/
mkdir -p out/
wget -nc https://github.com/libsdl-org/SDL_net/releases/download/release-2.2.0/SDL2_net-2.2.0.tar.gz -O dl/SDL2_net-2.2.0.tar.gz || true
tar xf dl/SDL2_net-2.2.0.tar.gz -C pkg/
cd pkg/SDL2_net-2.2.0

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
cp "${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr/lib/libSDL2_net-2.0.so.0.200.0" "${INSTALL_DIR}/libSDL2_net-2.0.so.0"
