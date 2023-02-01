#!/bin/bash -e

export TOOLCHAIN=$(pwd)/toolchain
./build-toolchain.sh
./build-tools.sh
./build-libs.sh
