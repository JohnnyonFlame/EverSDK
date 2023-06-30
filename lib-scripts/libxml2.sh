#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/
wget -nc https://download.gnome.org/sources/libxml2/2.9/libxml2-2.9.7.tar.xz -O dl/libxml2-2.9.7.tar.xz || true
tar xf dl/libxml2-2.9.7.tar.xz -C pkg/
cd pkg/libxml2-2.9.7

export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-O2"
export CXXFLAGS="-O2"

./configure \
	--with-python=no \
	--prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
	--host="arm-linux-gnueabihf"

make -j$(($(nproc)+1)) install
