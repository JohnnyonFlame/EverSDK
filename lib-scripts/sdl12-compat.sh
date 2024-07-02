#!/bin/bash -e

INSTALL_DIR=$(pwd)/out
mkdir -p dl/
mkdir -p pkg/
mkdir -p out/
wget -nc https://github.com/libsdl-org/sdl12-compat/archive/refs/tags/release-1.2.68.tar.gz -O dl/sdl12-compat-release-1.2.68.tar.gz || true
tar xf dl/sdl12-compat-release-1.2.68.tar.gz -C pkg/
cd pkg/sdl12-compat-release-1.2.68   

export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os -Wno-traditional"
export CXXFLAGS="-Os -Wno-traditional"
export LDFLAGS="-Os -flto"

cmake -Bbuild \
    -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN}/armhf.cmake \
    -DCMAKE_BUILD_TYPE=MinSizeRel \
    -DCMAKE_INSTALL_PREFIX="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr"

make -Cbuild -j$(($(nproc)+1)) install
cp "${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr/lib/libSDL-1.2.so.1.2.68" "$INSTALL_DIR/libSDL-1.2.so.0"
cp "${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr/bin/sdl-config" "${TOOLCHAIN}/bin/sdl-config" 
cp "${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr/lib/pkgconfig/sdl12_compat.pc" "${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr/lib/pkgconfig/sdl.pc"
chmod +x ${TOOLCHAIN}/bin/sdl-config