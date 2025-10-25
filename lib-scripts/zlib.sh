#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/
mkdir -p stamps/
STAMP=$(realpath "stamps/zlib-1.3.tar.gz")

[ -e "${STAMP}" ] && echo "Skipping zlib-1.3.tar.gz" && exit 0

./wget-helper.sh "zlib-1.3.tar.gz" "https://www.zlib.net/fossils/zlib-1.3.tar.gz"
tar xf dl/zlib-1.3.tar.gz -C pkg/
cd pkg/zlib-1.3

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

touch "${STAMP}" # Done
