#!/bin/bash -e

# For Dropbear to offer us SFTP, we need the OpenSSH server binary which is built
# elsewhere, and we need to point to a valid path to it using the SFTPSERVER_PATH
# macro. See CFLAGS for this.

INSTALL_DIR=$(pwd)/utils
mkdir -p ${INSTALL_DIR}
mkdir -p out/
mkdir -p pkg/
wget -nc https://matt.ucc.asn.au/dropbear/releases/dropbear-2022.83.tar.bz2 -O out/dropbear-2022.83.tar.bz2 || true
tar xf out/dropbear-2022.83.tar.bz2 -C pkg/
cd pkg/dropbear-2022.83

export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os -DSFTPSERVER_PATH='\"/tmp/sftp-server\"' -DDROPBEAR_PATH_SSH_PROGRAM='\"/tmp/dbclient\"'"
export CXXFLAGS="${CFLAGS}"

./configure \
    --prefix="${INSTALL_DIR}" \
    --host="arm-linux-gnueabihf" \
    --disable-syslog

make -j$(($(nproc)+1)) PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp" MULTI=1
cp dropbearmulti "${INSTALL_DIR}/"
