#!/bin/bash -e

INSTALL_DIR=$(pwd)/out
mkdir -p out/
mkdir -p dl/
mkdir -p pkg/
wget -nc https://ftp.gnu.org/gnu/parted/parted-3.6.tar.xz -O dl/parted-3.6.tar.xz || true
tar xf dl/parted-3.6.tar.xz -C pkg/
cp util-scripts/0001-parted.patch pkg/parted-3.6/
cd pkg/parted-3.6

export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os -flto"
export CFLAGS="${CFLAGS}"
export CXXFLAGS="${CFLAGS}"
export LDFLAGS="-flto"

patch -p2 < 0001-parted.patch
./configure \
    --prefix="${INSTALL_DIR}" \
    --host="arm-linux-gnueabihf" \
    --enable-static=yes --disable-device-mapper --without-readline --enable-shared=no

make -j$(($(nproc)+1))
cp pkg/parted-3.6/partprobe/partprobe ${INSTALL_DIR}/partprobe
