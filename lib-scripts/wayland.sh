#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/
wget -nc https://wayland.freedesktop.org/releases/wayland-1.18.0.tar.xz -O dl/wayland-1.18.0.tar.xz || true
tar xf dl/wayland-1.18.0.tar.xz -C pkg/
cd pkg/wayland-1.18.0

# Host bins (for wayland-scanner)
meson build-host/ \
    --prefix="${TOOLCHAIN}" \
	-Ddocumentation=false \
	-Ddtd_validation=false
	
ninja -C build-host/ install


# Root bins, specify libffi-3.2.1 include path to avoid odd breakage
CFLAGS=-I${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr/lib/libffi-3.2.1/include/ \
meson build/ \
	--cross-file "${TOOLCHAIN}/meson-cross.ini" \
	--build.pkg-config-path "${TOOLCHAIN}/lib/"*"/pkgconfig" \
	--pkg-config-path "${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config" \
	--default-library=shared \
	--prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
	--buildtype=release \
	-Ddocumentation=false \
	-Ddtd_validation=false

ninja -C build/ install

# Fix wayland-scanner detection on cross-compilation
sed -i "s#bindir=\${prefix}/bin#bindir=${TOOLCHAIN}/bin#" ${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr/lib/pkgconfig/wayland-scanner.pc
