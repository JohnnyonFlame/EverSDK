#!/bin/bash -e

mkdir -p out/
mkdir -p pkg/
wget -nc https://github.com/FluidSynth/fluidsynth/archive/refs/tags/v2.3.1.tar.gz -O out/fluidsynth-v2.3.1.tar.gz || true
tar xf out/fluidsynth-v2.3.1.tar.gz -C pkg/
cd pkg/fluidsynth-2.3.1

export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-O2 -Wno-traditional"
export CXXFLAGS="-O2 -Wno-traditional"

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
