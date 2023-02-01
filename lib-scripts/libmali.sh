#!/bin/bash -e
WSI=wayland

mkdir -p out/
mkdir -p pkg/
wget -nc https://github.com/JohnnyonFlame/libmali-jelos/archive/refs/heads/main.zip -O out/libmali.zip || true
export FILES=(libmali-jelos-main/lib/arm-linux-gnueabihf/libmali-utgard-450-r7p0-${WSI}.so "libmali-jelos-main/include/*")
(cd pkg/ && unzip -o ../out/libmali.zip "${FILES[@]}")

export PREFIX="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr"

# cp pkg/libmali-jelos-main/lib/arm-linux-gnueabihf/libmali-utgard-450-r7p0-wayland.so ${PREFIX}/lib/libmali-utgard-450-r7p0-wayland.so
cp pkg/libmali-jelos-main/lib/arm-linux-gnueabihf/libmali-utgard-450-r7p0-${WSI}.so ${PREFIX}/lib/libmali-utgard-450-r7p0-${WSI}.so
ln -sf ${PREFIX}/lib/libmali-utgard-450-r7p0-${WSI}.so ${PREFIX}/lib/libEGL.so
ln -sf ${PREFIX}/lib/libmali-utgard-450-r7p0-${WSI}.so ${PREFIX}/lib/libEGL.so.1
ln -sf ${PREFIX}/lib/libmali-utgard-450-r7p0-${WSI}.so ${PREFIX}/lib/libEGL.so.1.0.0
ln -sf ${PREFIX}/lib/libmali-utgard-450-r7p0-${WSI}.so ${PREFIX}/lib/libGLESv1_CM.so
ln -sf ${PREFIX}/lib/libmali-utgard-450-r7p0-${WSI}.so ${PREFIX}/lib/libGLESv1_CM.so.1
ln -sf ${PREFIX}/lib/libmali-utgard-450-r7p0-${WSI}.so ${PREFIX}/lib/libGLESv1_CM.so.1.0.0
ln -sf ${PREFIX}/lib/libmali-utgard-450-r7p0-${WSI}.so ${PREFIX}/lib/libGLESv2.so
ln -sf ${PREFIX}/lib/libmali-utgard-450-r7p0-${WSI}.so ${PREFIX}/lib/libGLESv2.so.2
ln -sf ${PREFIX}/lib/libmali-utgard-450-r7p0-${WSI}.so ${PREFIX}/lib/libGLESv2.so.2.0.0
ln -sf ${PREFIX}/lib/libmali-utgard-450-r7p0-${WSI}.so ${PREFIX}/lib/libOpenCL.so
ln -sf ${PREFIX}/lib/libmali-utgard-450-r7p0-${WSI}.so ${PREFIX}/lib/libgbm.so
ln -sf ${PREFIX}/lib/libmali-utgard-450-r7p0-${WSI}.so ${PREFIX}/lib/libgbm.so.1
ln -sf ${PREFIX}/lib/libmali-utgard-450-r7p0-${WSI}.so ${PREFIX}/lib/libgbm.so.1.9.0
ln -sf ${PREFIX}/lib/libmali-utgard-450-r7p0-${WSI}.so ${PREFIX}/lib/libmali.so
cp -r pkg/libmali-jelos-main/include/{EGL,GLES,GLES2,KHR} ${PREFIX}/include
cp -r pkg/libmali-jelos-main/include/GBM/* ${PREFIX}/include/

# Fix libmali.so.1 missing on Evercade VS
patchelf --set-soname libmali.so ${PREFIX}/lib/libmali-utgard-450-r7p0-${WSI}.so
