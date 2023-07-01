#!/bin/bash -e
MALI_VERSION=utgard-450-r7p0
WSI=wayland

mkdir -p dl/
mkdir -p pkg/
wget -nc https://github.com/JohnnyonFlame/libmali-jelos/archive/refs/heads/main.tar.gz -O dl/libmali.tar.gz || true
export FILES=("libmali-jelos-main/include" libmali-jelos-main/lib/arm-linux-gnueabihf/libmali-${MALI_VERSION}-${WSI}.so)
tar -C pkg/ -zxf dl/libmali.tar.gz "${FILES[@]}"

export PREFIX="${TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr"

cp pkg/libmali-jelos-main/lib/arm-linux-gnueabihf/libmali-${MALI_VERSION}-${WSI}.so ${PREFIX}/lib/libmali-${MALI_VERSION}-${WSI}.so
ln -sf ${PREFIX}/lib/libmali-${MALI_VERSION}-${WSI}.so ${PREFIX}/lib/libEGL.so
ln -sf ${PREFIX}/lib/libmali-${MALI_VERSION}-${WSI}.so ${PREFIX}/lib/libEGL.so.1
ln -sf ${PREFIX}/lib/libmali-${MALI_VERSION}-${WSI}.so ${PREFIX}/lib/libEGL.so.1.0.0
ln -sf ${PREFIX}/lib/libmali-${MALI_VERSION}-${WSI}.so ${PREFIX}/lib/libGLESv1_CM.so
ln -sf ${PREFIX}/lib/libmali-${MALI_VERSION}-${WSI}.so ${PREFIX}/lib/libGLESv1_CM.so.1
ln -sf ${PREFIX}/lib/libmali-${MALI_VERSION}-${WSI}.so ${PREFIX}/lib/libGLESv1_CM.so.1.0.0
ln -sf ${PREFIX}/lib/libmali-${MALI_VERSION}-${WSI}.so ${PREFIX}/lib/libGLESv2.so
ln -sf ${PREFIX}/lib/libmali-${MALI_VERSION}-${WSI}.so ${PREFIX}/lib/libGLESv2.so.2
ln -sf ${PREFIX}/lib/libmali-${MALI_VERSION}-${WSI}.so ${PREFIX}/lib/libGLESv2.so.2.0.0
ln -sf ${PREFIX}/lib/libmali-${MALI_VERSION}-${WSI}.so ${PREFIX}/lib/libOpenCL.so
ln -sf ${PREFIX}/lib/libmali-${MALI_VERSION}-${WSI}.so ${PREFIX}/lib/libgbm.so
ln -sf ${PREFIX}/lib/libmali-${MALI_VERSION}-${WSI}.so ${PREFIX}/lib/libgbm.so.1
ln -sf ${PREFIX}/lib/libmali-${MALI_VERSION}-${WSI}.so ${PREFIX}/lib/libgbm.so.1.9.0
ln -sf ${PREFIX}/lib/libmali-${MALI_VERSION}-${WSI}.so ${PREFIX}/lib/libmali.so
cp -r pkg/libmali-jelos-main/include/{EGL,GLES,GLES2,KHR} ${PREFIX}/include
cp -r pkg/libmali-jelos-main/include/KHR/mali_khrplatform.h ${PREFIX}/include/KHR/khrplatform.h
cp -r pkg/libmali-jelos-main/include/GBM/* ${PREFIX}/include/

# Fix libmali.so.1 missing on Evercade VS
patchelf --set-soname libmali.so ${PREFIX}/lib/libmali-${MALI_VERSION}-${WSI}.so

cp templates/{egl.pc,gbm.pc} ${PREFIX}/lib/pkgconfig
sed -i "s#TOOLCHAIN_PATH#${TOOLCHAIN}#" ${PREFIX}/lib/pkgconfig/egl.pc
sed -i "s#TOOLCHAIN_PATH#${TOOLCHAIN}#" ${PREFIX}/lib/pkgconfig/gbm.pc
sed -i "s#VERSION#22.0.0-${VERSION}#" ${PREFIX}/lib/pkgconfig/gbm.pc