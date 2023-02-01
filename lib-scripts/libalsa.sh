#!/bin/bash -e

mkdir -p out/
mkdir -p pkg/
wget -nc ftp://ftp.alsa-project.org/pub/lib/alsa-lib-1.2.4.tar.bz2 -O out/alsa-lib-1.2.4.tar.bz2 || true
tar xf out/alsa-lib-1.2.4.tar.bz2 -C pkg/
cd pkg/alsa-lib-1.2.4

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
