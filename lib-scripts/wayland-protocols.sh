#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/
mkdir -p stamps/
STAMP=$(realpath "stamps/wayland-protocols-1.18.tar.xz")

[ -e "${STAMP}" ] && echo "Skipping wayland-protocols-1.18.tar.xz" && exit 0

./wget-helper.sh "wayland-protocols-1.18.tar.xz" "https://wayland.freedesktop.org/releases/wayland-protocols-1.18.tar.xz"
tar xf dl/wayland-protocols-1.18.tar.xz -C pkg/
cd pkg/wayland-protocols-1.18

export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os -Wno-traditional"
export CXXFLAGS="-Os -Wno-traditional"
export LDFLAGS="-Os -flto"

./configure \
    --prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr"

make -j$(($(nproc)+1)) install

touch "${STAMP}" # Done
