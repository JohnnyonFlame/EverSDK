#!/bin/bash -e

mkdir -p out/
mkdir -p pkg/
wget -nc ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz -O out/libffi-3.2.1.tar.gz || true
tar xf out/libffi-3.2.1.tar.gz -C pkg/
cd pkg/libffi-3.2.1

export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-O2"
export CXXFLAGS="-O2"

./configure \
	--prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
	--host="arm-linux-gnueabihf" \
	--disable-static \
	--enable-shared

make -j$(($(nproc)+1)) install
