#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/{host,target}
wget -nc https://github.com/unicode-org/icu/releases/download/release-71-1/icu4c-71_1-src.tgz -O dl/icu4c-71_1-src.tgz || true
tar xf dl/icu4c-71_1-src.tgz -C pkg/host
tar xf dl/icu4c-71_1-src.tgz -C pkg/target
WITH_CROSS_BUILD=$(realpath "pkg/host/icu/source")

(
    cd pkg/host/icu/source

    ./configure \
        --prefix="${TOOLCHAIN}" \
        --enable-static \
        --disable-shared \
        --enable-extras=yes \
        --enable-strict=no \
        --enable-tests=no \
        --disable-renaming \
        --enable-samples=no \
        --disable-dyload

    make -j$(($(nproc)+1))
    make -j$(($(nproc)+1)) install
)

(
    cd pkg/target/icu/source
    
    export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
    export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
    export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
    export CFLAGS="-Os"
    export CXXFLAGS="-Os"

    ./configure \
        --with-cross-build="${WITH_CROSS_BUILD}" \
        --prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot" \
        --host="arm-linux-gnueabihf" \
        --enable-static \
        --enable-shared

    make clean
    make -j$(($(nproc)+1)) install
)
