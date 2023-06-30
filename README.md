### What is in this repository?

This repo contains a list of scripts, templates and tools to generate a working toolchain for the Evercade VS from scratch.

### Dependencies

Different systems might require a host of tools to get a build working, in ubuntu you might want:

```bash
sudo apt install -y git build-essential golang autoconf ninja-build meson cmake bison flex gawk gettext g++ help2man libncurses-dev libtool-bin texinfo unzip libffi-dev libexpat-dev patchelf gperf intltool
```

### How to build it?

```bash
cd eversdk
./build-sdk.sh
```

### Licensing
Copyright © 2023 João H. All Rights Reserved.
This is free software. The source files in this repository are released under the [GPLv2 License](LICENSE.md), see the license file for more information.
