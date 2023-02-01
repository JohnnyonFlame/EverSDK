#!/bin/bash

mkdir -p out/
mkdir -p pkg/
wget -nc https://download.gnome.org/sources/libxml2/2.9/libxml2-2.9.7.tar.xz -O out/libxml2-2.9.7.tar.xz || true
tar xf out/libxml2-2.9.7.tar.xz -C pkg/
cd pkg/libxml2-2.9.7

./configure \
	--prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
	--host="arm-linux-gnueabihf" \

make -j$(($(nproc)+1)) install
