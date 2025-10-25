#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/
mkdir -p stamps/
STAMP=$(realpath "stamps/libxkbcommon-1.0.3.tar.xz")

[ -e "${STAMP}" ] && echo "Skipping libxkbcommon-1.0.3.tar.xz" && exit 0

./wget-helper.sh "libxkbcommon-1.0.3.tar.xz" "https://xkbcommon.org/download/libxkbcommon-1.0.3.tar.xz"
tar xf dl/libxkbcommon-1.0.3.tar.xz -C pkg/
cd pkg/libxkbcommon-1.0.3

export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os"
export CXXFLAGS="-Os"
export LDFLAGS="-Os -flto"

meson build/ \
	--cross-file "${TOOLCHAIN}/meson-cross.ini" \
	--default-library=shared \
	--prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
	--buildtype=release \
	-Denable-x11=false \
	-Denable-xkbregistry=false \
	-Denable-wayland=false \
	-Denable-docs=false

ninja -C build/ install

touch "${STAMP}" # Done
