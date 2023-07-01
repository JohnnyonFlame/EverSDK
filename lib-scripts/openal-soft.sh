#!/bin/bash -e

INSTALL_DIR=$(pwd)/out
mkdir -p dl/
mkdir -p pkg/
mkdir -p out/
wget -nc https://openal-soft.org/openal-releases/openal-soft-1.23.1.tar.bz2 -O dl/openal-soft-1.23.1.tar.bz2 || true
tar xf dl/openal-soft-1.23.1.tar.bz2 -C pkg/
cd pkg/openal-soft-1.23.1

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
cp "${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr/lib/libopenal.so.1.23.1" "$INSTALL_DIR/libopenal.so.1"
