#!/bin/bash -e

OUT_FILE=$(realpath "out/shell.tar.gz")
rm -f ${OUT_FILE}
mkdir -p out/tmp_shell/tools
cp -r redist/shell/* out/tmp_shell/
cp ${TOOLCHAIN}/arm-linux-gnueabihf/lib/libstdc++.so.6 out/tmp_shell/tools
cp -r ${TOOLCHAIN}/arm-linux-gnueabihf/debug-root/usr/bin/* out/tmp_shell/tools
cp out/{dropbearmulti,sftp-server,avahi-daemon,avahi-daemon.conf} out/tmp_shell/tools
for i in out/tmp_shell/tools/*; do
    if readelf -h "$i" 2>/dev/null | grep -q "ELF"; then
        ${TOOLCHAIN}/bin/arm-linux-gnueabihf-strip "$i"
        patchelf --add-rpath '$ORIGIN' "$i"
    fi
done

(cd out/tmp_shell && tar -czf ${OUT_FILE} *)
rm -rf out/tmp_shell
