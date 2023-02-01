#!/bin/bash -e

mkdir -p out/ pkg/ ${TOOLCHAIN}
wget http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.25.0.tar.bz2 -O out/crosstool-ng-1.25.0.tar.bz2 || true
tar xf out/crosstool-ng-1.25.0.tar.bz2 -C pkg/
sed -E "s:CT_PREFIX_DIR=\"(.*)\":CT_PREFIX_DIR=\"${TOOLCHAIN}\":" templates/crosstool-config > pkg/crosstool-ng-1.25.0/.config

cd pkg/crosstool-ng-1.25.0
./configure --enable-local
make -j$(($(nproc)+1))
./ct-ng build
chmod -R 0777 ${TOOLCHAIN}
