#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/
wget -nc https://github.com/libsdl-org/SDL_image/releases/download/release-2.6.2/SDL2_image-2.6.2.tar.gz -O dl/SDL2_image-2.6.2.tar.gz || true
tar xf dl/SDL2_image-2.6.2.tar.gz -C pkg/
cd pkg/SDL2_image-2.6.2

export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-O2 -Wno-traditional"
export CXXFLAGS="-O2 -Wno-traditional"

./configure \
    --prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
    --host="arm-linux-gnueabihf" \
    --enable-static \
    --enable-shared

make clean
make -j$(($(nproc)+1)) install
