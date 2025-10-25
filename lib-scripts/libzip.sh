#!/bin/bash -e

INSTALL_DIR=$(pwd)/out
mkdir -p out/
mkdir -p dl/
mkdir -p pkg/
mkdir -p stamps/
STAMP=$(realpath "stamps/libzip-1.10.0.tar.xz")

[ -e "${STAMP}" ] && echo "Skipping libzip-1.10.0.tar.xz" && exit 0

./wget-helper.sh "libzip-1.10.0.tar.xz" "https://libzip.org/download/libzip-1.10.0.tar.xz"
tar xf dl/libzip-1.10.0.tar.xz -C pkg/
cd pkg/libzip-1.10.0

cmake -Bbuild \
    -DENABLE_COMMONCRYPTO=OFF \
    -DENABLE_GNUTLS=OFF \
    -DENABLE_MBEDTLS=OFF \
    -DENABLE_OPENSSL=OFF \
    -DENABLE_WINDOWS_CRYPTO=OFF \
    -DBUILD_SHARED_LIBS=OFF \
    -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN}/armhf.cmake \
    -DCMAKE_BUILD_TYPE=MinSizeRel \
    -DCMAKE_INSTALL_PREFIX="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr"

make -Cbuild -j$(($(nproc)+1)) install

cmake -Bbuild \
    -DENABLE_COMMONCRYPTO=OFF \
    -DENABLE_GNUTLS=OFF \
    -DENABLE_MBEDTLS=OFF \
    -DENABLE_OPENSSL=OFF \
    -DENABLE_WINDOWS_CRYPTO=OFF \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN}/armhf.cmake \
    -DCMAKE_BUILD_TYPE=MinSizeRel \
    -DCMAKE_INSTALL_PREFIX="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr"

make -Cbuild -j$(($(nproc)+1)) install
cp "${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr/lib/libzip.so.5.5" ${INSTALL_DIR}/libzip.so.5.5

touch "${STAMP}" # Done
