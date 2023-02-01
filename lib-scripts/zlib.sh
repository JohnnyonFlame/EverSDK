#!/bin/bash -e

mkdir -p out/
mkdir -p pkg/
wget -nc https://www.zlib.net/zlib-1.2.13.tar.gz -O out/zlib-1.2.13.tar.gz || true
tar xf out/zlib-1.2.13.tar.gz -C pkg/
cd pkg/zlib-1.2.13

export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-O2"
export CXXFLAGS="-O2"

./configure \
	--prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
	--shared

make -j$(($(nproc)+1)) install

./configure \
	--prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
	--static

make -j$(($(nproc)+1)) install
