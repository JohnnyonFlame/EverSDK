#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/
mkdir -p ${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/etc/cron.d/
wget -nc https://mirrors.edge.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.47.0/e2fsprogs-1.47.0.tar.gz -O dl/e2fsprogs-1.47.0.tar.gz || true
tar xf dl/e2fsprogs-1.47.0.tar.gz -C pkg/
cd pkg/e2fsprogs-1.47.0

export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os -flto"
export CFLAGS="${CFLAGS}"
export CXXFLAGS="${CFLAGS}"
export LDFLAGS="-Os -flto"

./configure \
    --prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
    --with-crond-dir="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/etc/cron.d/" \
    --host="arm-linux-gnueabihf" \

make -j$(($(nproc)+1))
make install
