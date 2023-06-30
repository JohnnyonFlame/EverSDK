#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/
wget -nc http://0pointer.de/lennart/projects/libdaemon/libdaemon-0.14.tar.gz -O dl/libdaemon-0.14.tar.gz || true
tar xf dl/libdaemon-0.14.tar.gz -C pkg/
cp pkg/crosstool-ng-*/scripts/config.sub pkg/libdaemon-0.14/config.sub
cp pkg/crosstool-ng-*/scripts/config.guess pkg/libdaemon-0.14/config.guess
cd pkg/libdaemon-0.14

export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os -I${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr/lib/libffi-3.2.1/include -Wno-format-overflow"
export CXXFLAGS="-Os -I${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr/lib/libffi-3.2.1/include -Wno-format-overflow"
export LDFLAGS="-Os -flto"

./configure \
    --prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
    --host="arm-linux-gnueabihf" \
    --enable-static \
    --disable-shared \
    ac_cv_func_setpgrp_void=true

make -j$(($(nproc)+1)) install
