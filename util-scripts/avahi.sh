#!/bin/bash -e

INSTALL_DIR=$(pwd)/out
mkdir -p ${INSTALL_DIR}
mkdir -p dl/
mkdir -p pkg/
wget -nc http://avahi.org/download/avahi-0.8.tar.gz -O dl/avahi-0.8.tar.gz || true
tar xf dl/avahi-0.8.tar.gz -C pkg/
cd pkg/avahi-0.8

export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os -flto"
export CXXFLAGS="-Os -flto"
export LDFLAGS="-Os -flto"

./configure \
    --prefix="${INSTALL_DIR}" \
    --host="arm-linux-gnueabihf" \
    --with-sysroot="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr" \
    --disable-manpages \
    --disable-xmltoman \
    --disable-monodoc \
    --disable-mono \
    --disable-python-dbus \
    --disable-pygobject \
    --disable-python \
    --disable-qt4 \
    --disable-qt5 \
    --disable-gtk \
    --disable-gtk3 \
    --disable-libevent \
    --disable-dbus \
    --disable-gdbm \
    --with-distro=none \
    --disable-dependency-tracking \
    --enable-static \
    --disable-shared \
    --with-avahi-user=root \
    --with-avahi-group=root \
    ac_cv_header_sys_capability_h=no

make -j$(($(nproc)+1))
cp avahi-daemon/avahi-daemon ${INSTALL_DIR}/avahi-daemon
cp avahi-daemon/avahi-daemon.conf ${INSTALL_DIR}/avahi-daemon.conf
