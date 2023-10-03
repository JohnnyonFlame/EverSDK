#!/bin/bash -e

INSTALL_DIR=$(pwd)/out
mkdir -p out/
mkdir -p dl/
mkdir -p pkg/
wget -nc https://www.libarchive.org/downloads/libarchive-3.6.2.tar.xz -O dl/libarchive-3.6.2.tar.xz || true
tar xf dl/libarchive-3.6.2.tar.xz -C pkg/

cp util-scripts/libarchive-no-paranoid.patch pkg/libarchive-3.6.2/libarchive-no-paranoid.patch
cd pkg/libarchive-3.6.2

export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os -flto"
export CFLAGS="${CFLAGS}"
export CXXFLAGS="${CFLAGS}"

patch -p1 < libarchive-no-paranoid.patch

# Not found on stock fw - let's hardlink lzma.
sed -i 's#-llzma#-l:liblzma.a#g' configure

./configure \
    --disable-dependency-tracking \
    --host="arm-linux-gnueabihf" \
    --without-bz2lib \
    --without-libb2 \
    --without-selinux \
    --with-openssl=no \
    --disable-bsdcpio \
    --disable-bsdcat \
    --disable-acl \
    --disable-xattr

make -j$(($(nproc)+1))
cp bsdtar ${INSTALL_DIR}/bsdtar
