#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/
mkdir -p stamps/
STAMP=$(realpath "stamps/xz-5.4.3.tar.xz")

[ -e "${STAMP}" ] && echo "Skipping xz-5.4.3.tar.xz" && exit 0

./wget-helper.sh "xz-5.4.3.tar.xz" "https://tukaani.org/xz/xz-5.4.3.tar.xz"
tar xf dl/xz-5.4.3.tar.xz -C pkg/
cd pkg/xz-5.4.3

export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os -ffunction-sections -fdata-sections"
export CXXFLAGS="-Os -ffunction-sections -fdata-sections"
export LDFLAGS="-Os -flto"

./configure \
	--prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
	--host="arm-linux-gnueabihf" \
	--enable-static

make -j$(($(nproc)+1)) install

touch "${STAMP}" # Done
