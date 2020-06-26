Building a driver for the ARM (AT91SAM9G45):

The kernel source code is required.
Download:
http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.30.tar.bz2
http://maxim.org.za/AT91RM9200/2.6/2.6.30-at91.patch.gz
ftp://www.at91.com/pub/linux/2.6.30-at91/2.6.30-at91-exp.4.tar.gz

and get from ClearCase:
/XLS_Linux/linux-kernel/LINUX_2.6.30_AT91_EXP.4_PMI2_0.0.patch

Extract the vanilla kernel

Apply the at91 maintainer patch:
  patch -p1 -i 2.6.30-at91.patch

Apply Atmel patches
  tar xvzf 2.6.30-at91-exp.4.tar.gz
  for p in 2.6.30-at91-exp.4/*; do patch -p1 -i $p ; done

Apply the XLS PMI2 patch
  patch -p1 -i LINUX_2.6.30_AT91_EXP.4_PMI2_0.0.patch

For the vanilla kernel in the source directory.
  make ARCH-arm CROSS_COMPILE=arm-angstrom-linux-gnueabi- at91sam9g45ekes_defconfig
  make ARCH-arm CROSS_COMPILE=arm-angstrom-linux-gnueabi- modules_prepare

For the xls kernel in the source directory (the one that we want).
  make ARCH-arm CROSS_COMPILE=arm-angstrom-linux-gnueabi- xlspmi2_defconfig
  make ARCH-arm CROSS_COMPILE=arm-angstrom-linux-gnueabi- modules_prepare

execute make to compile driver.
make

makefile {
ifneq ($(KERNELRELEASE),)
# we are inside the kernel tree and called from kernel build system
obj-m := rtserial_core.o
rtserial_core-objs = rtfifo.o rtserial_base.o

#obj-m := rtserial_core.o atmel_rs485_gpio.o rtserial_null.o
#obj-m += dummy_rt.o atmel_rs485_gpio.o atmel_pio_rs485.o
obj-m += atmel_spi_slave.o

else
# we are a separate module and start the kernel make and give it our directory
ARCH ?= arm
CROSS_COMPILE ?= arm-angstrom-linux-gnueabi-

CFLAGS += -g

#KERNELDIR ?= ../../../branches/ccp-ref/trunk
KERNELDIR ?= ../linux-2.6.30
PWD       := $(shell pwd)

CC = $(CROSS_COMPILE)gcc

all: driver

driver:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules
clean:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) clean
endif
}

Lindent:
a script that fixes the driver's formatting for Linus.
in the scripts directory in the kernel sources:
/linux-2.6.30/scripts/Lindent filename

checkpatch.pl:
a script that checks the driver's formatting for Linus.
in the scripts directory in the kernel sources:
/linux-2.6.30/scripts/checkpatch.pl -file filename

dmesg:
demsg - lets me read the kernel messages from dev_err, etc



Kernel build without Siemens patch (for demo n Chinese brd):

The kernel source code is required.
Download:
http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.30.tar.bz2
http://maxim.org.za/AT91RM9200/2.6/2.6.30-at91.patch.gz
ftp://www.at91.com/pub/linux/2.6.30-at91/2.6.30-at91-exp.4.tar.gz

and get from ClearCase:
/XLS_Linux/linux-kernel/LINUX_2.6.30_AT91_EXP.4_PMI2_0.0.patch

Extract the vanilla kernel

Apply the at91 maintainer patch:
  patch -p1 -i 2.6.30-at91.patch

Apply Atmel patches
  tar xvzf 2.6.30-at91-exp.4.tar.gz
  for p in 2.6.30-at91-exp.4/*; do patch -p1 -i $p ; done

Configuring the kernel for build:
Execute the following command
  make ARCH=arm menuconfig
from within the menu, load the .config file or create ur own config
  make ARCH=arm at91sam9g45ekes_defconfig // sets cfg
  make ARCH-arm CROSS_COMPILE=arm-angstrom-linux-gnueabi- uImage  // builds image

Loading the driver into the angstrom kernel:
create a directory for the dirver
tftp the driver over.
tftp -g -r filename.ko ip port

insmod driver.ko


SVN kernel download:
cli: svn checkout https://svn.hqs.sbt.siemens.com/viewvc/platform-linux/branches/corvus/trunk/


SVN certificate failure.
  There are 2 ways to fix this: copy the correct certificate to '/home/one/.subversion/auth/svn.ssl.server/', or execute svn and accept the certificate. 'svn checkout https://svn.hqs.sbt.siemens.com/viewvc/platform-linux/branches/corvus/trunk/'

If you stop the build process for any reason, you may have file that give you permission problems. Just delete these files, and restart the bitbake. Stopping creates permission problems from time to time.

If you modify a bb scrip, you may need to do bitbake -c clean <recipe name>. Then u need to go to the distfiles directory and delete the zip files associated with the recipe.


bu
Apply the at91 maintainer patch:
  patch -p1 < patch-2.6.32.41

