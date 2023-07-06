#!/bin/bash -e

INSTALL_DIR=$(pwd)/out
mkdir -p out/
mkdir -p dl/
mkdir -p pkg/
wget -nc https://github.com/jmacd/xdelta/archive/refs/tags/v3.1.0.tar.gz -O dl/xdelta3-3.1.0.tar.gz || true
tar xf dl/xdelta3-3.1.0.tar.gz -C pkg/
cd pkg/xdelta-3.1.0/xdelta3

export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os -flto"
export CFLAGS="${CFLAGS}"
export CXXFLAGS="${CFLAGS}"
export LDFLAGS="-Os -s -flto"

autoreconf -i
./configure \
    --prefix="${INSTALL_DIR}" \
    --host="arm-linux-gnueabihf" \
    --with-liblzma

sed -i 's#-llzma#-l:liblzma.a#g' Makefile
make -j$(($(nproc)+1))
cp xdelta3 ${INSTALL_DIR}/xdelta3
