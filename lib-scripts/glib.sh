#!/bin/bash -e

mkdir -p out/
mkdir -p pkg/
wget -nc https://download.gnome.org/sources/glib/2.54/glib-2.54.2.tar.xz -O out/glib-2.54.2.tar.xz || true
tar xf out/glib-2.54.2.tar.xz -C pkg/
cd pkg/glib-2.54.2

export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-O2 -I${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr/lib/libffi-3.2.1/include -Wno-format-overflow"
export CXXFLAGS="-O2 -I${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr/lib/libffi-3.2.1/include -Wno-format-overflow"

./configure \
    --prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
    --host="arm-linux-gnueabihf" \
    --enable-static \
    --enable-shared \
	glib_cv_pcre_has_unicode=true \
    glib_cv_stack_grows=false \
    glib_cv_uscore=false

make -j$(($(nproc)+1)) install
