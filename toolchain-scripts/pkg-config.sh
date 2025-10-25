#!/bin/bash -e

mkdir -p dl
mkdir -p pkg
mkdir -p stamps/
STAMP=$(realpath "stamps/pkg-config-0.29.2.tar.gz")

[ -e "${STAMP}" ] && echo "Skipping pkg-config-0.29.2.tar.gz" && exit 0

./wget-helper.sh "pkg-config-0.29.2.tar.gz" "https://pkgconfig.freedesktop.org/releases/pkg-config-0.29.2.tar.gz"
tar xf dl/pkg-config-0.29.2.tar.gz -C pkg/
cd pkg/pkg-config-0.29.2

./configure \
	--prefix="${TOOLCHAIN}/" \
	--with-pc-path="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr/lib/pkgconfig" \
	--with-internal-glib

make -j$(($(nproc)+1)) install
ln -sf ${TOOLCHAIN}/bin/pkg-config ${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config 

touch "${STAMP}" # Done
