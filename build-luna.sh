#!/bin/bash

set -e

rm -rf ../BUILD

export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache
ccache -M 50G
ccache -o compression=true

export ARCH=arm64
export CROSS_COMPILE=/media/igor/Android/bbry/aarch64-linux-android-4.9/bin/aarch64-linux-android-

make O=../BUILD CROSS_COMPILE=$CROSS_COMPILE ARCH=$ARCH mrproper

# TODO: perf?
#make CONFIG_BBRY=1 O=../BUILD CROSS_COMPILE=$CROSS_COMPILE ARCH=$ARCH athena-perf_defconfig

# use config extracted from device for now
cp config-from-luna-droidian ../BUILD/.config
make O=../BUILD CROSS_COMPILE=$CROSS_COMPILE ARCH=$ARCH CONFIG_SUNWAVE_FINGERPRINT=y -j12 Image.gz
cat ../BUILD/arch/arm64/boot/Image.gz '/media/igor/Android/bbry/android-linux-kernel/bimg/extractions/kernel.extracted/A80FC0/dtb1' '/media/igor/Android/bbry/android-linux-kernel/bimg/extractions/kernel.extracted/A80FC0/dtb2' '/media/igor/Android/bbry/android-linux-kernel/bimg/extractions/kernel.extracted/A80FC0/dtb3' > Image.gz-dtb
mkbootimg --header_version 0 --os_patch_level 2020-11 --os_version 8.1.0 --pagesize 4096 --tags_offset 0x100 --second_offset 0x00f00000 --ramdisk_offset 0x01000000 --kernel_offset 0x00008000 --base 0x0 --cmdline "earlycon=msm_serial_dm,0xc170000 androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x37 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 sched_enable_hmp=1 sched_enable_power_aware=1 pathtrust=0 service_locator.enable=1 swiotlb=1 androidboot.configfs=true androidboot.usbcontroller=a800000.dwc3 build_number=ACT575 androidboot.build_number=ACT575 coherent_pool=1280K buildvariant=user" --kernel Image.gz-dtb --ramdisk '/media/igor/Android/bbry/recovery/ramdisk'   --second '/media/igor/Android/bbry/android-linux-kernel/bimg/second'  --out newbootimg

