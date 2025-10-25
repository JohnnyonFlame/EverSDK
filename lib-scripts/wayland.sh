#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/host pkg/target
mkdir -p stamps/
STAMP=$(realpath "stamps/wayland-1.18.0.tar.xz")

[ -e "${STAMP}" ] && echo "Skipping wayland-1.18.0.tar.xz" && exit 0

./wget-helper.sh "wayland-1.18.0.tar.xz" "https://wayland.freedesktop.org/releases/wayland-1.18.0.tar.xz"
tar xf dl/wayland-1.18.0.tar.xz -C pkg/host
tar xf dl/wayland-1.18.0.tar.xz -C pkg/target

(
    cd pkg/host/wayland-1.18.0

    ./configure \
        --prefix="${TOOLCHAIN}" \
        --disable-dependency-tracking \
		--disable-dtd-validation \
		--disable-documentation \
		--disable-libraries

	make clean
    make -j$(($(nproc)+1)) install
)

(
    cd pkg/target/wayland-1.18.0
    
	export PATH="${TOOLCHAIN}/bin/:$PATH"
    export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
    export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
    export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
    export CFLAGS="-Os -ffunction-sections -fdata-sections"
    export CXXFLAGS="-Os -ffunction-sections -fdata-sections"
    export LDFLAGS="-Os -flto"

    ./configure \
        --prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
        --host="arm-linux-gnueabihf" \
        --enable-static \
        --enable-shared \
		--disable-dtd-validation \
		--disable-documentation \
		--with-host-scanner

	make clean
    make -j$(($(nproc)+1)) install
)

cp templates/wayland-egl.pc ${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr/lib/pkgconfig/wayland-egl.pc
sed -i "s#TOOLCHAIN_PATH#${TOOLCHAIN}#" ${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr/lib/pkgconfig/wayland-egl.pc
sed -i "s#exec_prefix=\${prefix}#exec_prefix=${TOOLCHAIN}#" ${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr/lib/pkgconfig/wayland-scanner.pc

touch "${STAMP}" # Done
