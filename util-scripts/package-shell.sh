#!/bin/bash -e

OUT=$(realpath "out/shell.tar.gz")
mkdir -p out/tmp_shell/
cp -r redist/shell/* out/tmp_shell/
${TOOLCHAIN}/bin/arm-linux-gnueabihf-strip out/{dropbearmulti,sftp-server,avahi-daemon}
cp out/{dropbearmulti,sftp-server,avahi-daemon,avahi-daemon.conf} out/tmp_shell/tools
chmod +x out/tmp_shell/special/shell.sh
(cd out/tmp_shell && tar -czf ${OUT} *)
rm -rf out/tmp_shell
