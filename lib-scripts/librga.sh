#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/linux-rga
mkdir -p stamps/
STAMP=$(realpath "stamps/eversdk-rga.tar.gz")

[ -e "${STAMP}" ] && echo "Skipping eversdk-rga.tar.gz" && exit 0

./wget-helper.sh "eversdk-rga.tar.gz" "https://github.com/JohnnyonFlame/linux-rga/archive/refs/tags/eversdk-rga.tar.gz"
tar xf dl/eversdk-rga.tar.gz --strip-components=1 -C pkg/linux-rga
cd pkg/linux-rga

export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os"
export CXXFLAGS="-Os"
export LDFLAGS="-Os -flto"

meson build/ \
	--cross-file "${TOOLCHAIN}/meson-cross.ini" \
	--default-library=static \
	--prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
    -Dbuildtype=minsize \
    -Dlibdrm=false

ninja -C build/ install

touch "${STAMP}" # Done
