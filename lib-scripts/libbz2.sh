#!/bin/bash -e

INSTALL_DIR=$(pwd)/out
mkdir -p dl/
mkdir -p pkg/
mkdir -p out/
mkdir -p stamps/
STAMP=$(realpath "stamps/bzip2-1.0.8.tar.gz")

[ -e "${STAMP}" ] && echo "Skipping bzip2-1.0.8.tar.gz" && exit 0

./wget-helper.sh "bzip2-1.0.8.tar.gz" "https://sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz"
tar xf dl/bzip2-1.0.8.tar.gz -C pkg/
cd pkg/bzip2-1.0.8

# export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
# export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
# export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
# export CFLAGS="-Os -Wno-traditional"
# export CXXFLAGS="-Os -Wno-traditional"
# export LDFLAGS="-Os -flto"

cp Makefile Makefile.eversdk
sed -i 's#CC=gcc#CC="$${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"#g' Makefile.eversdk
sed -i 's#AR=ar#AR="$${TOOLCHAIN}/bin/arm-linux-gnueabihf-ar"#g' Makefile.eversdk
sed -i 's#RANLIB=ranlib#RANLIB="$${TOOLCHAIN}/bin/arm-linux-gnueabihf-ranlib"#g' Makefile.eversdk
sed -i 's#PREFIX=/usr/local#PREFIX="$${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr"#g' Makefile.eversdk

make -f Makefile.eversdk -j$(($(nproc)+1)) install

touch "${STAMP}" # Done