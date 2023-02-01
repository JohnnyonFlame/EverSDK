#!/bin/bash

wget -nc https://pkgconfig.freedesktop.org/releases/pkg-config-0.29.2.tar.gz -O out/pkg-config-0.29.2.tar.gz || true
tar xf out/pkg-config-0.29.2.tar.gz -C pkg/
cd pkg/pkg-config-0.29.2

./configure \
	--prefix="${TOOLCHAIN}/" \
	--with-pc-path="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr/lib/pkgconfig" \
	--with-internal-glib

make -j$(($(nproc)+1)) install
ln -sf ${TOOLCHAIN}/bin/pkg-config ${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config 
