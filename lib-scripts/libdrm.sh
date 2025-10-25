#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/
mkdir -p stamps/
STAMP=$(realpath "stamps/libdrm-2.4.104.tar.xz")

[ -e "${STAMP}" ] && echo "Skipping libdrm-2.4.104.tar.xz" && exit 0

./wget-helper.sh "libdrm-2.4.104.tar.xz" "https://dri.freedesktop.org/libdrm/libdrm-2.4.104.tar.xz"
tar xf dl/libdrm-2.4.104.tar.xz -C pkg/
cd pkg/libdrm-2.4.104

export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os"
export CXXFLAGS="-Os"
export LDFLAGS="-Os -flto"

meson build/ \
	--cross-file "${TOOLCHAIN}/meson-cross.ini" \
	--default-library=shared \
	--prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
	--buildtype=release

ninja -C build/ install

touch "${STAMP}" # Done
