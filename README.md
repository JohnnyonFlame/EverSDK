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
!git clone https://github.com/JohnnyonFlame/EverSDK -b eversdk_handheld
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

### Licensing
Copyright © 2023 João H. All Rights Reserved.
This is free software. The source files in this repository are released under the [GPLv2 License](LICENSE.md), see the license file for more information.
