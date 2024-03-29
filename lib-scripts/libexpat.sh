#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/
wget -nc https://github.com/libexpat/libexpat/releases/download/R_2_2_5/expat-2.2.5.tar.bz2 -O dl/expat-2.2.5.tar.bz2 || true
tar xf dl/expat-2.2.5.tar.bz2 -C pkg/
cd pkg/expat-2.2.5

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
