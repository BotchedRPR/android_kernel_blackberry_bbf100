#!/bin/bash

rm -rf ../BUILD

export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache
ccache -M 50G
ccache -o compression=true

export ARCH=arm64
export CROSS_COMPILE=/home/ubuntu/bin/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-

make O=../BUILD CROSS_COMPILE=$CROSS_COMPILE ARCH=$ARCH mrproper

# TODO: perf?
#make CONFIG_BBRY=1 O=../BUILD CROSS_COMPILE=$CROSS_COMPILE ARCH=$ARCH athena-perf_defconfig

# use config extracted from device for now
cp config-from-athena-droidian ../BUILD/.config
make O=../BUILD CROSS_COMPILE=$CROSS_COMPILE ARCH=$ARCH -j12 Image.gz
