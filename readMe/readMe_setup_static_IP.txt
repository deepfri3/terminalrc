
/etc/network/interfaces

# Main PC NIC
auto eth0
#NetworkManager
#iface eth0 inet dhcp
iface eth0 inet static
hwaddress ether 00:26:b9:bf:6e:6e
address 136.157.0.100
netmask 255.255.255.0
network 136.157.0.0
broadcast 136.157.0.255
gateway 136.157.0.2

$ sudo ifconfig eth0
eth0      Link encap:Ethernet  HWaddr ec:b1:d7:40:4d:a8
          inet addr:136.157.0.101  Bcast:136.157.0.255  Mask:255.255.255.0
          inet6 addr: fe80::eeb1:d7ff:fe40:4da8/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:2121260 errors:0 dropped:0 overruns:0 frame:0
          TX packets:964723 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:1007507698 (960.8 MiB)  TX bytes:552951438 (527.3 MiB)
          Interrupt:20 Memory:f3100000-f3120000



