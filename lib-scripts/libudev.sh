#!/bin/bash -e

mkdir -p dl/
mkdir -p pkg/
wget -nc https://www.freedesktop.org/software/systemd/systemd-220.tar.xz -O dl/systemd-220.tar.xz || true
rm -rf pkg/systemd-220
tar xf dl/systemd-220.tar.xz -C pkg/
cd pkg/systemd-220

export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-O2 -Wno-traditional"
export CXXFLAGS="-O2 -Wno-traditional"

# Ugly compilation fixes...
sed -i 's#if test "${with_efi_ldsdir+set}" = set; then :#if false; then\nif test "${with_efi_ldsdir+set}" = set; then :#' configure
sed -i 's#  have_gnuefi=no#have_gnuefi=no\nfi#' configure
sed -i 's/#if !HAVE_DECL_RENAMEAT2/#if 0/' src/shared/missing.h
echo "#include <sys/sysmacros.h>" >> src/libsystemd/sd-device/device-private.h
echo "#include <sys/sysmacros.h>" >> src/libsystemd/sd-device/device-util.h

export PKG_CONFIG_PATH="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr/lib/pkgconfig"
./configure \
    --prefix="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
    --host="arm-linux-gnueabihf" \
    GLIB_CFLAGS=' ' \
    GLIB_LIBS=' ' \
    CPPFLAGS="${CFLAGS}" \
    CFLAGS="${CFLAGS}" \
    ac_cv_func_malloc_0_nonnull=yes \
    ac_cv_func_realloc_0_nonnull=yes

make -j$(($(nproc)+1)) \
        src/shared/errno-to-name.h \
        src/shared/errno-from-name.h \
        src/shared/af-to-name.h \
        src/shared/af-from-name.h \
        src/shared/cap-to-name.h \
        src/shared/cap-from-name.h \
        src/shared/arphrd-to-name.h \
        src/shared/arphrd-from-name.h || true

# We only need udev...
make -j$(($(nproc)+1)) libudev.la src/libudev/libudev.pc
cp src/libudev/libudev.h "${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr/include"
cp src/libudev/libudev.pc "${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr/lib/pkgconfig"
cp .libs/libudev.so "${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr/lib"
cp .libs/libudev.so.1 "${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr/lib"
cp .libs/libudev.so.1.6.3 "${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr/lib"
