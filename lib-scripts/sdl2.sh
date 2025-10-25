#!/bin/bash -e

INSTALL_DIR=$(pwd)/out
mkdir -p dl/
mkdir -p out/
mkdir -p pkg/SDL2-2.28.1
mkdir -p stamps/
STAMP=$(realpath "stamps/SDL2-2.28.1-eversdk-r2.tar.gz")

[ -e "${STAMP}" ] && echo "Skipping SDL2-2.28.1-eversdk-r2.tar.gz" && exit 0

./wget-helper.sh "SDL2-2.28.1-eversdk-r2.tar.gz" "https://github.com/JohnnyonFlame/SDL-fixkmsdrm/archive/refs/tags/eversdk-r2.tar.gz"
tar xf dl/SDL2-2.28.1-eversdk-r2.tar.gz --strip-components=1 -C pkg/SDL2-2.28.1
cd pkg/SDL2-2.28.1

export WAYLAND_SCANNER="${TOOLCHAIN}/bin/wayland-scanner"
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
    --enable-video-kmsdrm \
    --disable-pipewire \
    --disable-oss \
    --disable-video-wayland \
    --disable-video-x11 \
    --disable-video-rpi \
    --disable-video-vulkan

make -j$(($(nproc)+1)) install

sed 's:^exec_prefix=${prefix}:prefix="${prefix}/arm-linux-gnueabihf/sysroot/usr"\nexec_prefix=${prefix}:' sdl2-config > ${TOOLCHAIN}/bin/sdl2-config
chmod +x ${TOOLCHAIN}/bin/sdl2-config
cp "${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr/lib/libSDL2-2.0.so.0.2800.1" "${INSTALL_DIR}/libSDL2-2.0.so.0"

touch "${STAMP}" # Done
