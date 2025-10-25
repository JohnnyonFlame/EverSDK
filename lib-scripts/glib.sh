#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/
mkdir -p stamps/
STAMP=$(realpath "stamps/glib-2.54.2.tar.xz")

[ -e "${STAMP}" ] && echo "Skipping glib-2.54.2.tar.xz" && exit 0

./wget-helper.sh "glib-2.54.2.tar.xz" "https://download.gnome.org/sources/glib/2.54/glib-2.54.2.tar.xz"
tar xf dl/glib-2.54.2.tar.xz -C pkg/
cd pkg/glib-2.54.2

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
    --enable-shared \
	glib_cv_pcre_has_unicode=true \
    glib_cv_stack_grows=false \
    glib_cv_uscore=false

make -j$(($(nproc)+1)) install

touch "${STAMP}" # Done
