#!/bin/bash -e

INSTALL_DIR=$(pwd)/out
mkdir -p ${INSTALL_DIR}
mkdir -p dl/
mkdir -p pkg/
wget -nc https://github.com/troglobit/mdnsd/releases/download/v0.12/mdnsd-0.12.tar.gz -O dl/mdnsd-0.12.tar.gz || true
tar xf dl/mdnsd-0.12.tar.gz -C pkg/
cd pkg/mdnsd-0.12

export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os"
export CXXFLAGS="-Os"
export LDFLAGS="-Os -s -flto"

./configure \
    --prefix="${INSTALL_DIR}" \
    --host="arm-linux-gnueabihf" \
    --enable-static \
    --disable-doc \
    --disable-tests \
    --disable-dependency-tracking \
    --disable-shared

make -j$(($(nproc)+1))
cp src/mdnsd ${INSTALL_DIR}
