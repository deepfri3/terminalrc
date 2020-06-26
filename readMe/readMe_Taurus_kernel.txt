
Building the 2.6.32.41 kernel
downlaod the 2.6.32 vanilla kernel from kernel.org
download the patch-2.6.32.41.bz2 (bunzip2 patch-2.6.32.41

all patches are placed in the linux-2.6.32 dir
bunzip2 patch-2.6.32.41.bz2
patch -p1 < patch-2.6.32.41

zug specific patch:
get zug patch from oe dirs: 2.6.32.41-ARM-FSPLATFORM-1.0.patch.bz2
bunzip2 2.6.32.41-ARM-FSPLATFORM-1.0.patch.bz2
patch -p1 -i 2.6.32.41-ARM-FSPLATFORM-1.0.patch

Make the kernel from eval board cfg:
make ARCH=arm taurus_eval_defconfig
make ARCH=arm CROSS_COMPILE=arm-angstrom-linux-gnueabi- uImage

That was the easy part.

Adding a new config to the kernel:
The following instructions are specific to the Atmel at91 architecture, but the same process for any processor/architecture.

In kernel directory, linux-.../arch/arm/config, add the new config or copy an existing one.
I am using the taurus_eval configuration as my starting point. The names are arbitrary, but I want to stay consistent with the existing naming conventions. 
Copy the config name taurus_eval_defconfig to taurus_xdmc_defconfig.
In kernel directory, linux-.../arch/arm/mach-at91, copy the board-taurus-eval.c to board-taurus-xdmc.c.
References need to be added for compilation.

The .._defconfig files are makefile macros for compilation. The defines order or grouping is not necessary but they are grouped.
In the taurus_xdmc_defconfig find the board type section. Add "CONFIG_MACH_TAURUS_XDMC=y". Remove the other boards types (not needed).
In kernel directory, linux-.../arch/arm/mach-at91, add the following in the "ARCH_AT91SAM9G20" section to the Kconfig.

config MACH_TAURUS_XDMC
  bool "Siemens I BT Taurus module"
  depends on ARCH_AT91SAM9G20
  help
    Select this if you are using Simens' Taurus CPU module for the XDMC.


In kernel directory, linux-.../arch/arm/mach-at91, add "obj-$(CONFIG_MACH_TAURUS_XDMC) += board-taurus-xdmc.o" to the Makefile.

path to cross compiler may be different. it depends where it is located.
example CROSS_COMPILE=/home/projects/oe-stable-2012/build/xdmc/sysroots/i686-linux/usr/armv5te/bin/arm-angstrom-linux-gnueabi-


Make the kernel for xdmc board cfg:
make ARCH=arm CROSS_COMPILE=/home/projects/oe-stable-2012/build/xdmc/sysroots/i686-linux/usr/armv5te/bin/arm-angstrom-linux-gnueabi-clean
make ARCH=arm CROSS_COMPILE=/home/projects/oe-stable-2012/build/xdmc/sysroots/i686-linux/usr/armv5te/bin/arm-angstrom-linux-gnueabi- taurus_xdmc_defconfig
make ARCH=arm CROSS_COMPILE=/home/projects/oe-stable-2012/build/xdmc/sysroots/i686-linux/usr/armv5te/bin/arm-angstrom-linux-gnueabi- uImage

Now update the board-taurus-xdmc.c file with specific xdmc changes.

The uImage file is in the linux-.../arch/arm/boot direcotry. This is the file that you jtag into the flash.


Creating a patch for your changes:
Making a patch for bitbake:
diff -uNr linux-2.6.32/ linux-2.6.32_xdmc > linux_xdmc.patch
bzip2 linux_xdmc.patch
  - this example does not use paths for directories.
  - bz2 is the format that bitbake recognizes
  