#!/bin/bash -e

mkdir -p dl/ pkg/ ${TOOLCHAIN}
mkdir -p stamps/
STAMP=$(realpath "stamps/crosstool-ng-1.26.0.tar.xz")

[ -e "${STAMP}" ] && echo "Skipping crosstool-ng-1.26.0.tar.xz" && exit 0

./wget-helper.sh "crosstool-ng-1.26.0.tar.xz" "http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.26.0.tar.xz"
tar xf dl/crosstool-ng-1.26.0.tar.xz -C pkg/
sed -E "s:CT_PREFIX_DIR=\"(.*)\":CT_PREFIX_DIR=\"${TOOLCHAIN}\":" templates/crosstool-config > pkg/crosstool-ng-1.26.0/.config

cd pkg/crosstool-ng-1.26.0
./configure --enable-local
make -j$(($(nproc)+1))
./ct-ng build
chmod -R 0777 ${TOOLCHAIN}

touch "${STAMP}" # Done
