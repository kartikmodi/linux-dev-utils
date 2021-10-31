#!/bin/bash
set -x

#Install Quemu
sudo apt-get install qemu qemu-system

#Now create a disk for your virtual machine 
#for 16GB
qemu-img create $QEMU_IMG_FILE 16g

#Now format your disk with some file system; 
#ext4 in this example
# Using fully qualified path as this is not available in user's $PATH in vanilla debian
/usr/sbin/mkfs.ext4 $QEMU_IMG_FILE

#Now create a mount point directory for your image file
mkdir -p $MOUNT_DIR

#Next, mount your image to the directory
sudo mount -o loop $QEMU_IMG_FILE $MOUNT_DIR # sudo is required

#Install debootstrap
sudo apt -y install debootstrap

#Now get the OS release version using
cat /etc/os-release #bullseye

#Set family name. needs sudo
sudo /usr/sbin/debootstrap --arch amd64 $OS_RELEASE_NAME  $MOUNT_DIR

#Chroot and Now install all your required packages; lets start with vim and build_esstentials.
#sudo chroot $MOUNT_DIR && apt install vim build-essential ssh && echo "root" | passwd root --stdin

sudo chroot $MOUNT_DIR /bin/bash <<"EOT"
apt -y install vim less ssh
echo root:root | /usr/sbin/chpasswd
EOT

#Unmount. || /bin/true makes exit code 0. echo $?
sudo umount $MOUNT_DIR  || /bin/true


#You are all set. Now unmount your image file from the directory.
exit
