#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/
mkdir -p stamps/
STAMP=$(realpath "stamps/fluidsynth-v2.3.1.tar.gz")

[ -e "${STAMP}" ] && echo "Skipping fluidsynth-v2.3.1.tar.gz" && exit 0

./wget-helper.sh "fluidsynth-v2.3.1.tar.gz" "https://github.com/FluidSynth/fluidsynth/archive/refs/tags/v2.3.1.tar.gz"
tar xf dl/fluidsynth-v2.3.1.tar.gz -C pkg/
cd pkg/fluidsynth-2.3.1

export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os -Wno-traditional"
export CXXFLAGS="-Os -Wno-traditional"
export LDFLAGS="-Os -flto"

cmake -Bbuild \
    -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN}/armhf.cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
    -Denable-oss=0 \
    -Denable-libsndfile=0 \
    -Denable-dbus=0 \
    -Denable-pulseaudio=0 \
    -Denable-jack=0

make -Cbuild -j$(($(nproc)+1)) install

touch "${STAMP}" # Done
