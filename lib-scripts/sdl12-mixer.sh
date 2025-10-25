#!/bin/bash -e

INSTALL_DIR=$(pwd)/out
mkdir -p dl/
mkdir -p pkg/
mkdir -p out/
mkdir -p stamps/
STAMP=$(realpath "stamps/SDL_mixer-release-1.2.12.tar.gz")

[ -e "${STAMP}" ] && echo "Skipping SDL_mixer-release-1.2.12.tar.gz" && exit 0

./wget-helper.sh "SDL_mixer-release-1.2.12.tar.gz" "https://github.com/libsdl-org/SDL_mixer/archive/refs/tags/release-1.2.12.tar.gz"
tar xf dl/SDL_mixer-release-1.2.12.tar.gz -C pkg/
cd pkg/SDL_mixer-release-1.2.12

export SDL_CONFIG="${TOOLCHAIN}/bin/sdl-config"
export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os -ffunction-sections -fdata-sections -Wno-traditional"
export CXXFLAGS="-Os -ffunction-sections -fdata-sections -Wno-traditional"
export LDFLAGS="-Os -flto"

./configure \
    --prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
    --host="arm-linux-gnueabihf" \
    --build="arm-linux-gnueabihf" \
    --enable-static \
    --enable-shared

make clean
make -j$(($(nproc)+1)) install
cp "${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr/lib/libSDL_mixer-1.2.so.0.12.0" "${INSTALL_DIR}/libSDL_mixer-1.2.so.0"

touch "${STAMP}" # Done
