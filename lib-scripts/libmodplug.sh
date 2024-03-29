#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/
wget -nc https://sourceforge.net/projects/modplug-xmms/files/libmodplug/0.8.9.0/libmodplug-0.8.9.0.tar.gz -O dl/libmodplug-0.8.9.0.tar.gz || true
tar xf dl/libmodplug-0.8.9.0.tar.gz -C pkg/
cd pkg/libmodplug-0.8.9.0

export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os -Wno-traditional -ffunction-sections -fdata-sections"
export CXXFLAGS="-Os -Wno-traditional -ffunction-sections -fdata-sections"
export LDFLAGS="-Os -flto"

./configure \
    --prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
    --host="arm-linux-gnueabihf" \
    --enable-static \
    --enable-shared

make clean
make -j$(($(nproc)+1)) install
