#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/
wget -nc https://tukaani.org/xz/xz-5.4.3.tar.xz -O dl/xz-5.4.3.tar.xz || true
tar xf dl/xz-5.4.3.tar.xz -C pkg/
cd pkg/xz-5.4.3

export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os"
export CXXFLAGS="-Os"
export LDFLAGS="-Os -flto"

./configure \
	--prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
	--host="arm-linux-gnueabihf" \
	--enable-static

make -j$(($(nproc)+1)) install
