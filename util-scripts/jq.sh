#!/bin/bash -e

INSTALL_DIR=$(pwd)/out
mkdir -p ${INSTALL_DIR}
mkdir -p dl/
mkdir -p pkg/
wget -nc https://github.com/stedolan/jq/releases/download/jq-1.6/jq-1.6.tar.gz -O dl/jq-1.6.tar.gz || true
tar xf dl/jq-1.6.tar.gz -C pkg/
cd pkg/jq-1.6

export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os"
export CXXFLAGS="-Os"

autoreconf -fi
./configure \
    --host="arm-linux-gnueabihf" \
    --with-oniguruma=builtin \
    --disable-maintainer-mode

make -j$(($(nproc)+1))
cp jq "${INSTALL_DIR}/jq"
${TOOLCHAIN}/bin/arm-linux-gnueabihf-strip -s "${INSTALL_DIR}/jq"
