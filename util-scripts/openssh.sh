#!/bin/bash -e

INSTALL_DIR=$(pwd)/out
mkdir -p ${INSTALL_DIR}
mkdir -p dl/
mkdir -p pkg/
mkdir -p stamps/
STAMP=$(realpath "stamps/openssh-V_9_5_P1.tar.gz")

[ -e "${STAMP}" ] && echo "Skipping openssh-V_9_5_P1.tar.gz" && exit 0

./wget-helper.sh "openssh-V_9_5_P1.tar.gz" "https://github.com/openssh/openssh-portable/archive/refs/tags/V_9_5_P1.tar.gz"
tar xf dl/openssh-V_9_5_P1.tar.gz -C pkg/
cd pkg/openssh-portable-V_9_5_P1

export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os"
export CXXFLAGS="-Os"
export LDFLAGS="-Os -s -flto"

autoreconf
./configure \
    --host="arm-linux-gnueabihf" \
    --without-openssl \
    --without-audit \
    --without-lastlog \
    --without-osfsia \
    --without-ssl-engine \
    --without-openssl-header-check \
    --without-pam \
    --without-xauth

make -j$(($(nproc)+1)) sftp-server
cp sftp-server "${INSTALL_DIR}/"

touch "${STAMP}" # Done
