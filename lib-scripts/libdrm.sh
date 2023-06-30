#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/
wget -nc https://dri.freedesktop.org/libdrm/libdrm-2.4.104.tar.xz -O dl/libdrm-2.4.104.tar.xz || true
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
