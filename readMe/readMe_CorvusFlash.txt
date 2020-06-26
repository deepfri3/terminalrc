This is a Readme for flashing a Corvus board for the PMI-2 with all the components required:

AT ANY POINT DO NOT POWER CYCLE YOUR BOARD UNLESS EXPLICITLY STATED

The assumption is that the board already contains the bootstrap and U-Boot and that all the 
commands written here will be typed at the U-Boot command line:

Set up MAC Addr, IP addr, and server ip addr
First, blow away the existing envvars:

nand erase 0x100000 0x100000
nand erase clean 0x100000 0x100000
reset 

Next setup the environment variables for developer:
 
setenv ethaddr 12:34:56:78:9a:bc
setenv ipaddr 192.168.251.200
      
Set the server IP to whatever the IP address on the USB-to-Ethernet dongle is:
  
setenv serverip <Server IP>
saveenv
      
Now get ready to transfer files over to the board. Start up your TFTP server on your PC side and 
point it to where your local copies of the kernel and RootFS are. Then type the following 
commands at the U-Boot prompt:
  
Transferring and burning the kernel:

tftp 0x701f0000 uImage
nand erase 0x200000
nand erase clean 0x200000
nand write 0x701f0000 0x200000 0x200000
      
Transferring and burning the RootFS:

tftp 0x74000000 rootfs.img
nand erase 0x400000
nand erase clean 0x400000
setenv rootfssize $filesize
nand write 0x74000000 0x400000 $rootfssize
      
YOU CAN NOW POWER CYCLE YOUR BOARD.     
Now when the board boots U-boot should boot the kernel and you should be able to mount the filesystem
