#!/bin/bash -e

INSTALL_DIR=$(pwd)/out
mkdir -p dl/
mkdir -p pkg/
mkdir -p out/
mkdir -p stamps/
STAMP=$(realpath "stamps/SDL2_net-2.2.0.tar.gz")

[ -e "${STAMP}" ] && echo "Skipping SDL2_net-2.2.0.tar.gz" && exit 0

./wget-helper.sh "SDL2_net-2.2.0.tar.gz" "https://github.com/libsdl-org/SDL_net/releases/download/release-2.2.0/SDL2_net-2.2.0.tar.gz"
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

touch "${STAMP}" # Done
