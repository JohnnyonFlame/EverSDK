#!/bin/bash -e

INSTALL_DIR=$(pwd)/out
mkdir -p dl/
mkdir -p pkg/
mkdir -p out/
mkdir -p stamps/
STAMP=$(realpath "stamps/tre-0.8.0.tar.gz")

[ -e "${STAMP}" ] && echo "Skipping tre-0.8.0.tar.gz" && exit 0

./wget-helper.sh "tre-0.8.0.tar.gz" "http://laurikari.net/tre/tre-0.8.0.tar.gz"
tar xf dl/tre-0.8.0.tar.gz -C pkg/
cd pkg/tre-0.8.0

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

make -j$(($(nproc)+1)) install
cp "${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr/lib/libtre.so.5.0.0" "${INSTALL_DIR}/libtre.so.5"

touch "${STAMP}" # Done
