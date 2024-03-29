#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/
wget -nc https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.36/util-linux-2.36.2.tar.xz -O dl/util-linux-2.36.2.tar.xz || true
tar xf dl/util-linux-2.36.2.tar.xz -C pkg/
cd pkg/util-linux-2.36.2

export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os"
export CXXFLAGS="-Os"
export LDFLAGS="-Os -flto"

./configure \
	--prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
	--host="arm-linux-gnueabihf" \
	--disable-all-programs \
	--enable-libblkid \
	--enable-libmount

make -j$(($(nproc)+1)) install
