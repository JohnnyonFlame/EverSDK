#!/bin/bash

OUT=$(realpath "out/gdb.tar.gz")
mkdir -p out/gdb_tmp/tools
rm -f ${OUT}
cp -r toolchain/arm-linux-gnueabihf/debug-root/usr/bin/* out/gdb_tmp/tools
cp toolchain/arm-linux-gnueabihf/lib/libstdc++.so.6 out/gdb_tmp/tools
${TOOLCHAIN}/bin/arm-linux-gnueabihf-strip out/gdb_tmp/tools/{strace,gdb,gdbserver}
(cd out/gdb_tmp/ && tar -czf ${OUT} *)
rm -rf out/gdb_tmp
