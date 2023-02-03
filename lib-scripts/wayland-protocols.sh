#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/
wget -nc https://wayland.freedesktop.org/releases/wayland-protocols-1.18.tar.xz -O dl/wayland-protocols-1.18.tar.xz || true
tar xf dl/wayland-protocols-1.18.tar.xz -C pkg/
cd pkg/wayland-protocols-1.18

export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-O2 -Wno-traditional"
export CXXFLAGS="-O2 -Wno-traditional"

./configure \
    --prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr"

make -j$(($(nproc)+1)) install
