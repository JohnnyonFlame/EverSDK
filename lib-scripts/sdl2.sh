#!/bin/bash -e

INSTALL_DIR=$(pwd)/out
mkdir -p dl/
mkdir -p pkg/
mkdir -p out/
wget -nc https://github.com/libsdl-org/SDL/releases/download/release-2.26.2/SDL2-2.26.2.tar.gz -O dl/SDL2-2.26.2.tar.gz || true
tar xf dl/SDL2-2.26.2.tar.gz -C pkg/
cp lib-scripts/SDL2_*.patch pkg/SDL2-2.26.2/
cd pkg/SDL2-2.26.2

export WAYLAND_SCANNER="${TOOLCHAIN}/bin/wayland-scanner"
export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os -Wno-traditional"
export CXXFLAGS="-Os -Wno-traditional"
export LDFLAGS="-Os -flto"

patch -p1 < SDL2_evercade_controller.patch
patch -p1 < SDL2_wl_114.patch

./configure \
    --prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
    --host="arm-linux-gnueabihf" \
    --enable-static \
    --enable-shared \
    --enable-video-kmsdrm \
    --disable-video-wayland \
    --disable-video-x11 \
    --disable-video-rpi \
    --disable-video-vulkan

make -j$(($(nproc)+1)) install

sed 's:^exec_prefix=${prefix}:prefix="${prefix}/arm-linux-gnueabihf/sysroot/usr"\nexec_prefix=${prefix}:' sdl2-config > ${TOOLCHAIN}/bin/sdl2-config
chmod +x ${TOOLCHAIN}/bin/sdl2-config
cp "${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr/lib/libSDL2-2.0.so.0.2600.2" "${INSTALL_DIR}/libSDL2-2.0.so.0"
