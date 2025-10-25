#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/
mkdir -p stamps/
STAMP=$(realpath "stamps/libffi-3.2.1.tar.gz")

[ -e "${STAMP}" ] && echo "Skipping libffi-3.2.1.tar.gz" && exit 0

./wget-helper.sh "libffi-3.2.1.tar.gz" "ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz"
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

touch "${STAMP}" # Done
