#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/
wget -nc https://download.savannah.gnu.org/releases/freetype/freetype-2.12.1.tar.xz -O dl/freetype-2.12.1.tar.xz || true
tar xf dl/freetype-2.12.1.tar.xz -C pkg/
cd pkg/freetype-2.12.1

export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os"
export CXXFLAGS="-Os"
export LDFLAGS="-Os -flto"

meson build/ \
	--cross-file "${TOOLCHAIN}/meson-cross.ini" \
	--default-library=static \
	--prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
	--buildtype=release

ninja -C build/ install

meson build/ \
	--reconfigure \
    --cross-file "${TOOLCHAIN}/meson-cross.ini" \
	--default-library=shared \
	--prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
	--buildtype=release

ninja -C build/ install
