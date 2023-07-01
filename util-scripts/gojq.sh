#!/bin/bash -e

INSTALL_DIR=$(pwd)/out
mkdir -p dl/
mkdir -p out/
mkdir -p pkg/

wget -nc http://deb.debian.org/debian/pool/main/g/gojq/gojq_0.12.11.orig.tar.gz -O dl/gojq_0.12.11.orig.tar.gz || true
tar xf dl/gojq_0.12.11.orig.tar.gz -C pkg/
cd pkg/gojq-0.12.11

export CGO_ENABLED=1
export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export GOARM=7
export GOGC=off
export GOOS=linux
export GOARCH=arm

go build -ldflags="-w -s" -gcflags=all="-l -B -wb=false" -buildmode=pie -o gojq ./cmd/gojq/
cp gojq ${INSTALL_DIR}/gojq
