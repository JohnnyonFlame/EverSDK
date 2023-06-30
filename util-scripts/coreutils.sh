#!/bin/bash -e

INSTALL_DIR=$(pwd)/out
mkdir -p out/
mkdir -p dl/
mkdir -p pkg/
wget -nc https://ftp.gnu.org/gnu/coreutils/coreutils-9.3.tar.xz -O dl/coreutils-9.3.tar.xz || true
tar xf dl/coreutils-9.3.tar.xz -C pkg/
cd pkg/coreutils-9.3

export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
export CFLAGS="-Os -flto"
export CFLAGS="${CFLAGS}"
export CXXFLAGS="${CFLAGS}"
export LDFLAGS="-Os -s -flto"

./configure \
    --host="arm-linux-gnueabihf" \
    --disable-dependency-tracking \
    --disable-acl \
    --without-selinux \
    --with-openssl=no \
    ac_year2038_required=no

make -j$(($(nproc)+1))
cp src/realpath "${INSTALL_DIR}/realpath"
