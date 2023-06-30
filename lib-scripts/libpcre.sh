#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/
wget -nc https://sourceforge.net/projects/pcre/files/pcre/8.41/pcre-8.41.tar.bz2 -O dl/pcre-8.41.tar.bz2 || true
tar xf dl/pcre-8.41.tar.bz2 -C pkg/
cd pkg/pcre-8.41

export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os -Wno-traditional"
export CXXFLAGS="-Os -Wno-traditional"
export LDFLAGS="-Os -flto"

./configure \
    --prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
    --host="arm-linux-gnueabihf" \
    --enable-utf8 \
    --enable-pcre16 \
    --enable-pcre32 \
    --enable-static \
    --enable-unicode-properties \
    --enable-shared

make -j$(($(nproc)+1)) install
