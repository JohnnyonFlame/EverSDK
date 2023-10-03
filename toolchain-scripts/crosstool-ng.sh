#!/bin/bash -e

mkdir -p dl/ pkg/ ${TOOLCHAIN}
wget http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.26.0.tar.xz -O dl/crosstool-ng-1.26.0.tar.xz || true
tar xf dl/crosstool-ng-1.26.0.tar.xz -C pkg/
sed -E "s:CT_PREFIX_DIR=\"(.*)\":CT_PREFIX_DIR=\"${TOOLCHAIN}\":" templates/crosstool-config > pkg/crosstool-ng-1.26.0/.config

cd pkg/crosstool-ng-1.26.0
./configure --enable-local
make -j$(($(nproc)+1))
./ct-ng build
chmod -R 0777 ${TOOLCHAIN}