#!/bin/bash
# set -x # x print commands and their arguments as they are executed

#Pass the release name
export BASE=$YOUR_LINUX_DEV_UTILS_PATH
export OS_RELEASE_NAME=bullseye
export QEMU_BASE_PATH=$BASE/qemu
export QEMU_IMG=$QEMU_BASE_PATH
export KERN_SRC=$YOUR_LINUX_SRC_PATH
export KERNEL=$BASE/KERNEL
#CPU parallelism
export PARA="-j18"

export VER="4.17.19" # 4.17.0 doesn't exist on kernel official. it starts from 4.17.1
export QEMU_IMG_FILE=$QEMU_BASE_PATH/qemu-image.img
export MOUNT_DIR=$BASE/qemu/mountdir
export QEMUMEM="500M"
export ARCH=x86_64
# gives no erorrs, handles parents
mkdir -p $KERNEL
mkdir -p $QEMU_BASE_PATH
# set +x # turning off x behaviour
