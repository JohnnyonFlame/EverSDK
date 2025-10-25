#!/bin/bash -e

INSTALL_DIR=$(pwd)/out
mkdir -p dl/
mkdir -p pkg/
mkdir -p out/
mkdir -p stamps/
STAMP=$(realpath "stamps/SDL2_mixer-2.8.0.tar.gz")

[ -e "${STAMP}" ] && echo "Skipping SDL2_mixer-2.8.0.tar.gz" && exit 0

./wget-helper.sh "SDL2_mixer-2.8.0.tar.gz" "https://github.com/libsdl-org/SDL_mixer/releases/download/release-2.8.0/SDL2_mixer-2.8.0.tar.gz"
tar xf dl/SDL2_mixer-2.8.0.tar.gz -C pkg/
cd pkg/SDL2_mixer-2.8.0

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
cp "${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr/lib/libSDL2_mixer-2.0.so.0.800.0" "${INSTALL_DIR}/libSDL2_mixer-2.0.so.0"

touch "${STAMP}" # Done
