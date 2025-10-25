#!/bin/bash -e
shopt -s nocaseglob
FILE=$1
URL=$2
OUTPUT="dl/${FILE}"

# Check if the file exists or if we need to fetch it
if [ ! -f "${OUTPUT}" ]; then
    wget -nc "${URL}" -O "${OUTPUT}" || true
fi

HASH_EXPECTED=""
case "$FILE" in
    alsa-lib-1.2.4.tar.bz2)                 HASH_EXPECTED="f7554be1a56cdff468b58fc1c29b95b64864c590038dd309c7a978c7116908f7";;
    android-tools-eversdk.tar.gz)           HASH_EXPECTED="5b1f8fc47fd43ead92201ad46db56d171a26edbeb66d0363e88ed0f1e5559532";;
    avahi-0.8.tar.gz)                       HASH_EXPECTED="060309d7a333d38d951bc27598c677af1796934dbd98e1024e7ad8de798fedda";;
    bzip2-1.0.8.tar.gz)                     HASH_EXPECTED="ab5a03176ee106d3f0fa90e381da478ddae405918153cca248e682cd0c4a2269";;
    coreutils-9.3.tar.xz)                   HASH_EXPECTED="adbcfcfe899235b71e8768dcf07cd532520b7f54f9a8064843f8d199a904bbaa";;
    crosstool-ng-1.26.0.tar.xz)             HASH_EXPECTED="e8ce69c5c8ca8d904e6923ccf86c53576761b9cf219e2e69235b139c8e1b74fc";;
    dropbear-2022.83.tar.bz2)               HASH_EXPECTED="bc5a121ffbc94b5171ad5ebe01be42746d50aa797c9549a4639894a16749443b";;
    e2fsprogs-1.47.0.tar.gz)                HASH_EXPECTED="0b4fe723d779b0927fb83c9ae709bc7b40f66d7df36433bef143e41c54257084";;
    eversdk-rga.tar.gz)                     HASH_EXPECTED="a8f74e18c5528dd8032e7e481cd07aa00af539976eb944c4540606b20d4de4aa";;
    expat-2.2.5.tar.bz2)                    HASH_EXPECTED="d9dc32efba7e74f788fcc4f212a43216fc37cf5f23f4c2339664d473353aedf6";;
    fluidsynth-v2.3.1.tar.gz)               HASH_EXPECTED="d734e4cf488be763cf123e5976f3154f0094815093eecdf71e0e9ae148431883";;
    freetype-2.12.1.tar.xz)                 HASH_EXPECTED="4766f20157cc4cf0cd292f80bf917f92d1c439b243ac3018debf6b9140c41a7f";;
    gl4es-1.1.6.tar.gz)                     HASH_EXPECTED="dca1d897e492a0cb163a3390f273fbd4cc7ab2367d236d93dc2b321ce108ed5c";;
    glib-2.54.2.tar.xz)                     HASH_EXPECTED="bb89e5c5aad33169a8c7f28b45671c7899c12f74caf707737f784d7102758e6c";;
    gojq_0.12.11.orig.tar.gz)               HASH_EXPECTED="8fa747f787ba81a9c6979d3323a94897a64e7561263a82b795adcb21f7f40637";;
    icu4c-71_1-src.tgz)                     HASH_EXPECTED="67a7e6e51f61faf1306b6935333e13b2c48abd8da6d2f46ce6adca24b1e21ebf";;
    jq-1.6.tar.gz)                          HASH_EXPECTED="5de8c8e29aaa3fb9cc6b47bb27299f271354ebb72514e3accadc7d38b5bbaa72";;
    libarchive-3.6.2.tar.xz)                HASH_EXPECTED="9e2c1b80d5fbe59b61308fdfab6c79b5021d7ff4ff2489fb12daf0a96a83551d";;
    libatomic_ops-7.8.2.tar.gz)             HASH_EXPECTED="d305207fe207f2b3fb5cb4c019da12b44ce3fcbc593dfd5080d867b1a2419b51";;
    libcap-2.49.tar.gz)                     HASH_EXPECTED="ab55ef5dcec7519feb0f61d9a5b6565ba1909a4f1c86f16cbb9ae1aa1132e1f0";;
    libdaemon-0.14.tar.gz)                  HASH_EXPECTED="fd23eb5f6f986dcc7e708307355ba3289abe03cc381fc47a80bca4a50aa6b834";;
    libdrm-2.4.104.tar.xz)                  HASH_EXPECTED="d66ad8b5c2441015ac1333e40137bb803c3bde3612ff040286fcc12158ea1bcb";;
    libffi-3.2.1.tar.gz)                    HASH_EXPECTED="d06ebb8e1d9a22d19e38d63fdb83954253f39bedc5d46232a05645685722ca37";;
    libmali.tar.gz)                         HASH_EXPECTED="c9a5f20d17e7ed476c0dd6cec0afe6009c4e8168e5cf0a3f3769951ccb7a0dc1";;
    libmodplug-0.8.9.0.tar.gz)              HASH_EXPECTED="457ca5a6c179656d66c01505c0d95fafaead4329b9dbaa0f997d00a3508ad9de";;
    libogg-1.3.5.tar.gz)                    HASH_EXPECTED="0eb4b4b9420a0f51db142ba3f9c64b333f826532dc0f48c6410ae51f4799b664";;
    libpng-1.6.43.tar.gz)                   HASH_EXPECTED="e804e465d4b109b5ad285a8fb71f0dd3f74f0068f91ce3cdfde618180c174925";;
    libvorbis-1.3.7.tar.gz)                 HASH_EXPECTED="0e982409a9c3fc82ee06e08205b1355e5c6aa4c36bca58146ef399621b0ce5ab";;
    libvpx-1.15.2.tar.gz)                   HASH_EXPECTED="26fcd3db88045dee380e581862a6ef106f49b74b6396ee95c2993a260b4636aa";;
    libxkbcommon-1.0.3.tar.xz)              HASH_EXPECTED="a2202f851e072b84e64a395212cbd976ee18a8ee602008b0bad02a13247dbc52";;
    libxml2-2.9.7.tar.xz)                   HASH_EXPECTED="6437855f3332fcc0fc25323c5f06901e02277e1232a662b621dc88fde37259ac";;
    libzip-1.10.0.tar.xz)                   HASH_EXPECTED="cd2a7ac9f1fb5bfa6218272d9929955dc7237515bba6e14b5ad0e1d1e2212b43";;
    openal-soft-1.23.1.tar.bz2)             HASH_EXPECTED="796f4b89134c4e57270b7f0d755f0fa3435b90da437b745160a49bd41c845b21";;
    openssh-V_9_5_P1.tar.gz)                HASH_EXPECTED="41760d6bfea3e6e35c6acc40d24f14863cfdc92c6e56ae9401db9c658cbd93b5";;
    openssl-3.2.0.tar.gz)                   HASH_EXPECTED="14c826f07c7e433706fb5c69fa9e25dab95684844b4c962a2cf1bf183eb4690e";;
    opus-1.1.2.tar.gz)                      HASH_EXPECTED="0e290078e31211baa7b5886bcc8ab6bc048b9fc83882532da4a1a45e58e907fd";;
    opusfile-0.12.tar.gz)                   HASH_EXPECTED="118d8601c12dd6a44f52423e68ca9083cc9f2bfe72da7a8c1acb22a80ae3550b";;
    pcre-8.41.tar.bz2)                      HASH_EXPECTED="e62c7eac5ae7c0e7286db61ff82912e1c0b7a0c13706616e94a7dd729321b530";;
    pkg-config-0.29.2.tar.gz)               HASH_EXPECTED="6fc69c01688c9458a57eb9a1664c9aba372ccda420a02bf4429fe610e7e7d591";;
    SDL_mixer-release-1.2.12.tar.gz)        HASH_EXPECTED="4176dfc887664419bfd16c41013c6cf0c48eca6b95ae3c34205630e8a7a94faa";;
    sdl12-compat-release-1.2.68.tar.gz)     HASH_EXPECTED="63c6e4dcc1154299e6f363c872900be7f3dcb3e42b9f8f57e05442ec3d89d02d";;
    SDL2_image-2.6.2.tar.gz)                HASH_EXPECTED="48355fb4d8d00bac639cd1c4f4a7661c4afef2c212af60b340e06b7059814777";;
    SDL2_mixer-2.6.2.tar.gz)                HASH_EXPECTED="8cdea810366decba3c33d32b8071bccd1c309b2499a54946d92b48e6922aa371";;
    SDL2_mixer-2.8.0.tar.gz)                HASH_EXPECTED="1cfb34c87b26dbdbc7afd68c4f545c0116ab5f90bbfecc5aebe2a9cb4bb31549";;
    SDL2_net-2.2.0.tar.gz)                  HASH_EXPECTED="4e4a891988316271974ff4e9585ed1ef729a123d22c08bd473129179dc857feb";;
    SDL2-2.28.1-eversdk-r2.tar.gz)          HASH_EXPECTED="5692a6ab874fc4eb573c15c984344d9462b2e6fe0216a0ad280b1a80aa3fcd15";;
    systemd-220.tar.xz)                     HASH_EXPECTED="3659588c40221ee7257502c0735491f72796dbe17be560013f6d310deb446332";;
    tre-0.8.0.tar.gz)                       HASH_EXPECTED="be8670a55198bc57485a6a8ae4b497d7db98ea25f90968585b7eb07d94c6a7dd";;
    util-linux-2.36.2.tar.xz)               HASH_EXPECTED="f7516ba9d8689343594356f0e5e1a5f0da34adfbc89023437735872bb5024c5f";;
    wayland-1.18.0.tar.xz)                  HASH_EXPECTED="4675a79f091020817a98fd0484e7208c8762242266967f55a67776936c2e294d";;
    wayland-protocols-1.18.tar.xz)          HASH_EXPECTED="3d73b7e7661763dc09d7d9107678400101ecff2b5b1e531674abfa81e04874b3";;
    xdelta3-3.1.0.tar.gz)                   HASH_EXPECTED="7515cf5378fca287a57f4e2fee1094aabc79569cfe60d91e06021a8fd7bae29d";;
    xz-5.4.3.tar.xz)                        HASH_EXPECTED="92177bef62c3824b4badc524f8abcce54a20b7dbcfb84cde0a2eb8b49159518c";;
    zlib-1.3.tar.gz)                        HASH_EXPECTED="ff0ba4c292013dbc27530b3a81e1f9a813cd39de01ca5e0f8bf355702efa593e";;
esac

if [ -z "${HASH_EXPECTED}" ]; then
    echo "File '${FILE}' is not on the hash list."
    exit -1
fi

HASH_FOUND="$(sha256sum "${OUTPUT}" | cut -f1 -d' ')"
if [ "${HASH_FOUND}" != "${HASH_EXPECTED}" ]; then
    echo " -- BUILD FAILURE -- "
    echo "File '${FILE}' hash mismatch, aborting."
    echo "Please report this as this might be a security problem."
    echo "Expected: ${HASH_EXPECTED}"
    echo "Found:    ${HASH_FOUND}"
    exit -1
fi

echo "${FILE} hash OK: ${HASH_FOUND}"

# All good!
exit 0