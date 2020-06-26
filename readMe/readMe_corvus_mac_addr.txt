In case you ALREADY HAD a MAC address stored that you want to replace, do the following:

Connect debug serial to header J21 on the PMI2 with the connector on the serial cable alligned with pin 1.
Start TeraTerm.
Select the correct USB-to-serial COM port

Reboot the PMI...
Hit any key to enter U-boot

U-Boot> nand erase 0x100000 0x100000
U-Boot> nand erase clean 0x100000 0x100000
U-Boot> reset 

Now when the board comes back up, do a "setenv" and saveenv with the new MAC address 
At the U-Boot command line, type out these lines:

U-Boot> setenv ethaddr 12:34:56:78:9a:bc
U-Boot> setenv ipaddr 192.168.251.200

Set the server IP to whatever the IP address on the USB-to-Ethernet dongle is:

U-Boot> setenv serverip 192.168.251.1

Verify your changes:

U-Boot> printenv

You should see something like this:

ethaddr=12:34:56:78:9A:BC
ipaddr=192.168.251.200
serverip=192.168.251.1

Save

U-Boot> saveenv 

