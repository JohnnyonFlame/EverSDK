#!/bin/bash -e

INSTALL_DIR=$(pwd)/out/gl4es
mkdir -p dl/
mkdir -p pkg/
mkdir -p "${INSTALL_DIR}"
wget -nc https://github.com/ptitSeb/gl4es/archive/refs/tags/v1.1.6.tar.gz -O dl/gl4es-1.1.6.tar.gz || true
tar xf dl/gl4es-1.1.6.tar.gz -C pkg/
cd pkg/gl4es-1.1.6

export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os -Wno-traditional"
export CXXFLAGS="-Os -Wno-traditional"
export LDFLAGS="-Os -flto"

cmake -Bbuild \
    -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN}/armhf.cmake \
    -DCMAKE_BUILD_TYPE=MinSizeRel \
    -DGBM=ON \
    -DNOX11=ON \
    -DEGL_WRAPPER=ON \
    -DGLX_STUBS=ON

make -Cbuild -j$(($(nproc)+1))
cp lib/* "${INSTALL_DIR}"
arm-linux-gnueabihf-strip "${INSTALL_DIR}"/*
