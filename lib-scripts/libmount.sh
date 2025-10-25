#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/
mkdir -p stamps/
STAMP=$(realpath "stamps/util-linux-2.36.2.tar.xz")

[ -e "${STAMP}" ] && echo "Skipping util-linux-2.36.2.tar.xz" && exit 0

./wget-helper.sh "util-linux-2.36.2.tar.xz" "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.36/util-linux-2.36.2.tar.xz"
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

touch "${STAMP}" # Done
