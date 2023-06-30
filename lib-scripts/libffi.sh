#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/
wget -nc ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz -O dl/libffi-3.2.1.tar.gz || true
tar xf dl/libffi-3.2.1.tar.gz -C pkg/
cd pkg/libffi-3.2.1

export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os"
export CXXFLAGS="-Os"
export LDFLAGS="-Os -flto"

./configure \
	--prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
	--host="arm-linux-gnueabihf" \
	--disable-static \
	--enable-shared

make -j$(($(nproc)+1)) install
