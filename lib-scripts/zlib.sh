#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/
wget -nc https://www.zlib.net/zlib-1.2.13.tar.gz -O dl/zlib-1.2.13.tar.gz || true
tar xf dl/zlib-1.2.13.tar.gz -C pkg/
cd pkg/zlib-1.2.13

export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os"
export CXXFLAGS="-Os"
export LDFLAGS="-Os -flto"

./configure \
	--prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
	--shared

make -j$(($(nproc)+1)) install

./configure \
	--prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
	--static

make -j$(($(nproc)+1)) install
