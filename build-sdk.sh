#!/bin/bash -e

export TOOLCHAIN=$(pwd)/toolchain
./build-toolchain.sh
./build-libs.sh
./build-utils.sh
