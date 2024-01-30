#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/
wget -nc https://www.openssl.org/source/openssl-3.2.0.tar.gz -O dl/openssl-3.2.0.tar.gz || true
tar xf dl/openssl-3.2.0.tar.gz -C pkg/
cd pkg/openssl-3.2.0
export CFLAGS="-Os -ffunction-sections -fdata-sections"
export CXXFLAGS="-Os -ffunction-sections -fdata-sections"
export LDFLAGS="-Os -flto"
export PATH="${TOOLCHAIN}/bin:${PATH}"

sed -i 's/-pthread/-lpthread/g' Configure
sed -i 's/-pthread/-lpthread/g' Configurations/10-main.conf

./Configure linux-armv4 \
	--prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
	--cross-compile-prefix="arm-linux-gnueabihf-" \
    shared threads no-ssl-trace no-ssl3 no-unit-test -latomic -fPIC

make -j$(($(nproc)+1))
make -j$(($(nproc)+1)) install
# make -j$(($(nproc)+1)) install
