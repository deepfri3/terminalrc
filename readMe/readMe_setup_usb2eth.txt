These instructions are for the Trendet TU2-ET100 model.

Plugin the dongle and run 'lsusb'. you should see an entry like this:
Bus 003 Device 014: ID 0b95:7720 ASIX Electronics Corp. AX88772

The ID "0b95:7720" in the ID indicates that this is model AX88772

Now Install the driver for the usb-2-eth dongle.

Driver Download:
http://www.asix.com.tw/download.php?sub=driverdetail&PItemID=86

Download the Linux driver.
Ex: AX88772C_772B_772A_760_772_178_LINUX_DRIVER_v4.17.3_Source.tar.gz 

untar the driver, cd into the directory

Follow the "Getting Start" directions in the file "readme":
make
sudo make install

Driver is now installed.

Load the module driver by the following:
modprobe asix
or
insmod asix

Use lsmod to verify the driver:
=>bakerg@Kane:~/Downloads/AX88772C_772B_772A_760_772_178_LINUX_DRIVER_v4.17.3_Source$ lsmod | grep asix
asix                   56961  0
mii                    12675  1 asix
usbcore               195468  6 asix,usb_storage,ehci_hcd,ehci_pci,usbhid,xhci_hcd

Check the following file for the usb-2-eth:
/etc/udev/rules.d/70-persistent-net.rules

For example I have 2 trendnet TU2-ET100 usb-2-eth dongles connected. Here is what they look like in 70-persistent-net.rules:
# USB device 0x:0x (asix)
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:50:b6:4d:18:c4", ATTR{dev_id}=="0x0", ATTR{type}=="1", KERNEL=="eth*", NAME="eth1"

# USB device 0x:0x (asix)
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:14:d1:da:f9:b9", ATTR{dev_id}=="0x0", ATTR{type}=="1", KERNEL=="eth*", NAME="eth2"

The address is the MAC address of the dongle. At the end is the eth number to match up with the /etc/network/interfaces file

Configuring your /etc/network/interfaces

For static eth connection (for connecting to a PMI-2):
# USB-to-ETH connection (PMI2)
Allow-hotplug eth1
Iface eth1 inet static
Address 192.168.251.1
Netmask 255.255.255.0
#network 192.168.251.0
Broadcast 192.168.251.255

For a DHCP eth connection (for connecting to network):
# USB-to-ETH connection (Network)
auto eth2
allow-hotplug eth2
iface eth2 inet dhcp
