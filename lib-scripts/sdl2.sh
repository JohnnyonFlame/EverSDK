#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/
wget -nc https://github.com/libsdl-org/SDL/releases/download/release-2.26.2/SDL2-2.26.2.tar.gz -O dl/SDL2-2.26.2.tar.gz || true
tar xf dl/SDL2-2.26.2.tar.gz -C pkg/
cd pkg/SDL2-2.26.2

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
    --enable-video-wayland \
    --enable-video-kmsdrm \
    --disable-video-x11 \
    --disable-video-rpi \
    --disable-video-vulkan

make -j$(($(nproc)+1)) install

sed 's:^exec_prefix=${prefix}:prefix="${prefix}/arm-linux-gnueabihf/sysroot/usr"\nexec_prefix=${prefix}:' sdl2-config > ${TOOLCHAIN}/bin/sdl2-config
chmod +x ${TOOLCHAIN}/bin/sdl2-config
