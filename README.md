### What is in this repository?

This repo contains a list of scripts, templates and tools to generate a working toolchain for the Evercade VS from scratch.

### Dependencies

Different systems might require a host of tools to get a build working, in ubuntu you might want:

```bash
sudo apt install -yy git build-essential autoconf ninja-build meson cmake bison flex gawk gettext g++ help2man libncurses-dev libtool-bin texinfo unzip libffi-dev libexpat-dev patchelf gperf intltool golang
```

### How to build it?

- On Ubuntu 22.04:
```bash
sudo apt install -yy git build-essential autoconf ninja-build meson cmake bison flex gawk gettext g++ help2man libncurses-dev libtool-bin texinfo unzip libffi-dev libexpat-dev patchelf gperf intltool golang
cd eversdk
./build-sdk.sh
```

- On Google Colab:
```py
!sudo apt install -yy git build-essential autoconf ninja-build meson cmake bison flex gawk gettext g++ help2man libncurses-dev libtool-bin texinfo unzip libffi-dev libexpat-dev patchelf gperf intltool golang
!git clone https://github.com/JohnnyonFlame/EverSDK
!echo "CT_EXPERIMENTAL=y" >> EverSDK/templates/crosstool-config
!echo "CT_ALLOW_BUILD_AS_ROOT=y" >> EverSDK/templates/crosstool-config
!echo "CT_ALLOW_BUILD_AS_ROOT_SURE=y" >> EverSDK/templates/crosstool-config
!cd EverSDK && \
  unset LD_LIBRARY_PATH && \
  unset LIBRARY_PATH && \
  export FORCE_UNSAFE_CONFIGURE=1 && \
  ./build-sdk.sh
!tar -czf EverSDK.tar.gz EverSDK/
```

### On deploying and debugging.

The `out/shell.tar.gz` package will be built once the compilation process is finished,
that contains a series of applications and tools to allow you to remotely deploy and
debug homebrew with ease on your Evercade VS with an EverSD.

To use this, extract the package on your EverSD, run the Shell application and you'll
be able to ssh/scp into `root@cobalt` with the password `eversdk`.

### How do I use this?

You can use this to build a variety of different project types, the building scripts are kept straightforward with the sake of serving as a quick reference, such as [building with go](util-scripts/gojq.sh), [GNU Configure](util-scripts/parted.sh) and [Meson](lib-scripts/libfreetype.sh).
The toolchain files for common build systems such as CMake, Meson are generated for you in `toolchain` on the EverSDK folder once the SDK is built.

E.g. To build with CMake:
```bash
export EVERSDK=</path/to/your/eversdk/build>
cmake -Bbuild -DCMAKE_TOOLCHAIN_FILE=${EVERSDK}/toolchain/armhf.cmake -DCMAKE_BUILD_TYPE=Release
make -C build -j$(($(nproc)+1))
```

### Licensing
Copyright © 2023 João H. All Rights Reserved.
This is free software. The source files in this repository are released under the [GPLv2 License](LICENSE.md), see the license file for more information.
