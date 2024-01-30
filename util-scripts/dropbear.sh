#!/bin/bash -e

# For Dropbear to offer us SFTP, we need the OpenSSH server binary which is built
# elsewhere, and we need to point to a valid path to it using the SFTPSERVER_PATH
# macro. See CFLAGS for this.

INSTALL_DIR=$(pwd)/out
mkdir -p ${INSTALL_DIR}
mkdir -p dl/
mkdir -p pkg/
wget -nc https://matt.ucc.asn.au/dropbear/releases/dropbear-2022.83.tar.bz2 -O dl/dropbear-2022.83.tar.bz2 || true
tar xf dl/dropbear-2022.83.tar.bz2 -C pkg/
cd pkg/dropbear-2022.83

export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os -flto -DSFTPSERVER_PATH='\"/tmp/sftp-server\"' -DDROPBEAR_PATH_SSH_PROGRAM='\"/tmp/dbclient\"'"
export CFLAGS="${CFLAGS} -DDEFAULT_PATH='\"/usr/bin:/bin:/tmp\"' -DDEFAULT_ROOT_PATH='\"/usr/sbin:/usr/bin:/sbin:/bin:/tmp\"'"
export CXXFLAGS="${CFLAGS}"
export LDFLAGS="-Os -flto"

# -- THIS IS EVIL --
# Terrible hack to force the password to be "eversdk" for every user
# You can create your own hash with: `openssl passwd -5 -salt vs new_password_goes_here`
sed -i 's/ses.authstate.pw_passwd = m_strdup(passwd_crypt);/ses.authstate.pw_passwd = m_strdup("$5$vs$jWTiufyRtfALzG0xwG0PiEiuxvEnIbzXA8ekIseqX06");/g' common-session.c

./configure \
    --prefix="${INSTALL_DIR}" \
    --host="arm-linux-gnueabihf" \
    --disable-syslog

make -j$(($(nproc)+1)) PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp" MULTI=1
cp dropbearmulti "${INSTALL_DIR}/"
