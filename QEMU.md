# QEMU setup for kernel hacking.

QEMU enables you to run a virtual machine either on a bare-metal OS or inside another virtual machine. 
More details of QEMU can be found here (https://www.qemu.org/).

The instructions and scripts below helps you to get started with a compiling a custom kernel and running a 
QEMU virtual machine using the compiled kernel.

For this semester's class, we will use Linux 4.17.

### Note:  

While the following  instructions to compile a custom kernel for QEMU will not affect or overwrite the original kernel of your system/laptop in which you are running, it is your responsibility to make sure you understand each of the script commands and know what you are doing. The kernels are compiled and written to the project directory rather than the "boot" folder.

You are more than welcome to use your own custom kernel compilation methods and running a QEMU!

### Installing Git 
```
sudo apt -y install git
git clone https://github.com/r/AdvOS
cd AdvOS
```

### Set environmental variables
```
source scripts/setvars.sh "trusty"
```

### Getting Kernel Source
We will be using linux-4.17 kernel this semester
```
cd $BASE
wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.17.tar.xz
tar xf linux-4.17.tar.xz


# https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/?h=linux-4.17.y # refer website
# https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/?h=v4.17.19 # refer website 

git clone --depth 1 --branch linux-4.17.y https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git

git clone --branch linux-4.17.y https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git # if want history with latest minor of 4.17

git clone --branch linux-4.17.19 https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git # if exact version with history
```

### Install required libraries (Follow ansible script for this kernel development, kernel programming)
```
# libelf-dev # Makefile:970: *** "Cannot generate ORC metadata for CONFIG_UNWINDER_ORC=y, please install libelf-dev, libelf-devel or elfutils-libelf-devel".  Stop.
sudo apt-get install -y build-essential cmake libssl-dev bison flex
```

### Compiling and launching QEMU 
From the source directory set the environment variables.
trusty specifies the host system's linux version/codename; pass your own OS version name using the following command
```
sudo lsb_release -a
```

```shell
source scripts/setvars.sh "trusty" 
```


```
Then generate a configuration file
```
cd linux-4.17
# sudo make x86_64_defconfig
make x86_64_defconfig # sudo is not required because we are doing in home dir subpath
```

Time to switch off SELINUX as it could cause issues in some versions. Open the .config file 
and comment selinux
```
vim .config
#CONFIG_SECURITY_SELINUX=y
```

Now, let's run the compilation script. If you are prompted for disabling SELINUX, just hit enter.
```
cd ...
$BASE/scripts/compile_kern.sh
```

### Create the QEMU IMAGE  

Create the QEMU IMAGE only for the first time. You should
not create an image (which is your disk now) every time you will be
compiling and testing your kernel.

During installation, if prompted (y,n), enter yes
```
$BASE/scripts/qemu_create.sh  
```

### Setting your QEMU image 

Next, we will have to set password for the VM, and install required packages 
for the QEMU
```
cd $BASE 
source scripts/setvars.sh "trusty"
$BASE/scripts/mount_qemu.sh
cd $MOUNT_DIR   //Go to where the QEMU disk is mounted
sudo chroot .  //Set the disk as your root file system
passwd         //Add new password for the root user in the virtual machine
sudo apt-get install -y build-essential cmake libssl-dev  //Install packages
exit           //Unmount the QEMU disk
cd $BASE       
$BASE/scripts/umount_qemu.sh  //Unmount the QEMU disk
```

### Now launch the QEMU
This script will use the compiled 4.17 kernel to run the QEMU
```
$BASE/scripts/run_qemu.sh
```

### Killing the QEMU process
```
$BASE/scripts/killqemu.sh
```

### Copying data from your host to QEMU
If you want to copy some data between your machine and QEMU disk image, then use the following script for convenience
This scripts copies directories/files from your host machine to QEMU's root folder
```
$BASE/scripts/copy_data_to_qemu.sh FULL_PATH_OF_DIRECTORY_TO_COPY
```

### Kernel error debugging

https://opensourceforu.com/2011/01/understanding-a-kernel-oops/



