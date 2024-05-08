#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/linux-rga
wget -nc https://github.com/JohnnyonFlame/linux-rga/archive/refs/tags/eversdk-rga.tar.gz -O dl/eversdk-rga.tar.gz || true
tar xf dl/eversdk-rga.tar.gz --strip-components=1 -C pkg/linux-rga
cd pkg/linux-rga

export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os"
export CXXFLAGS="-Os"
export LDFLAGS="-Os -flto"

meson build/ \
	--cross-file "${TOOLCHAIN}/meson-cross.ini" \
	--default-library=static \
	--prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
    -Dbuildtype=minsize \
    -Dlibdrm=false

ninja -C build/ install
