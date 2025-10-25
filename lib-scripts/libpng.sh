#!/bin/bash -e

INSTALL_DIR=$(pwd)/out
mkdir -p out/
mkdir -p dl/
mkdir -p pkg/
mkdir -p stamps/
STAMP=$(realpath "stamps/libpng-1.6.43.tar.gz")

[ -e "${STAMP}" ] && echo "Skipping libpng-1.6.43.tar.gz" && exit 0

./wget-helper.sh "libpng-1.6.43.tar.gz" "https://download.sourceforge.net/libpng/libpng-1.6.43.tar.gz"
tar xf dl/libpng-1.6.43.tar.gz -C pkg/
cd pkg/libpng-1.6.43

export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os -ffunction-sections -fdata-sections -Wno-traditional"
export CXXFLAGS="-Os -ffunction-sections -fdata-sections -Wno-traditional"
export LDFLAGS="-Os -flto"

./configure \
    --prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
    --host="arm-linux-gnueabihf" \
    --enable-static \
    --enable-shared

make clean
make -j$(($(nproc)+1)) install

touch "${STAMP}" # Done
