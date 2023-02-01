#!/bin/bash -e

mkdir -p out/
mkdir -p pkg/
wget -nc https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.36/util-linux-2.36.2.tar.xz -O out/util-linux-2.36.2.tar.xz || true
tar xf out/util-linux-2.36.2.tar.xz -C pkg/
cd pkg/util-linux-2.36.2

export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-O2"
export CXXFLAGS="-O2"

./configure \
	--prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
	--host="arm-linux-gnueabihf" \
	--disable-all-programs \
	--enable-libblkid \
	--enable-libmount

make -j$(($(nproc)+1)) install
