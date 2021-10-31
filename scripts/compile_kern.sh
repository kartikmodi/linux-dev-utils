#!/bin/bash
set -x

#If current mounted, unmount
#sudo umount $MOUNT_DIR  || /bin/true

#Compile the kernel
# cd $KERN_SRC

#Enable the KVM mode in your kernel config file
#sudo make menuconfig
#sudo make x86_64_defconfig
#sudo make kvmconfig

#Compile the kernel with '-j' (denotes parallelism) in sudo mode
make $PARA -C $KERN_SRC
make modules -C $KERN_SRC
linux_version="4.19.208"

# \ uses the original cp command and not any defined alias
\cp $KERN_SRC/arch/x86/boot/bzImage $KERNEL/vmlinuz-$linux_version
\cp $KERN_SRC/System.map $KERNEL/System.map-$linux_version
\cp $KERN_SRC/.config $KERNEL/config-$linux_version
#sudo update-initramfs -c -k $y
set +x
