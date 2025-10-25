#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/
mkdir -p stamps/
STAMP=$(realpath "stamps/libvpx-1.15.2.tar.gz")

[ -e "${STAMP}" ] && echo "Skipping libvpx-1.15.2.tar.gz" && exit 0

./wget-helper.sh "libvpx-1.15.2.tar.gz" "https://github.com/webmproject/libvpx/archive/refs/tags/v1.15.2.tar.gz"
mkdir -p pkg/libvpx-1.15.2
tar xf dl/libvpx-1.15.2.tar.gz --strip-components=1 -C pkg/libvpx-1.15.2
cd pkg/libvpx-1.15.2

export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export AS="${TOOLCHAIN}/bin/arm-linux-gnueabihf-as"
export LD="${TOOLCHAIN}/bin/arm-linux-gnueabihf-ld"
export STRIP="${TOOLCHAIN}/bin/arm-linux-gnueabihf-strip"
export AR="${TOOLCHAIN}/bin/arm-linux-gnueabihf-ar"
export CFLAGS="-Os -Wno-traditional -ffunction-sections -fdata-sections"
export CXXFLAGS="-Os -ffunction-sections -fdata-sections"
export LDFLAGS="-Os -flto"

./configure \
    --prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
    --target="armv7-linux-gcc" \
    --enable-static \
    --enable-shared \
    --enable-small

make -j$(($(nproc)+1)) install

touch "${STAMP}" # Done
