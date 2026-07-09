
/etc/network/interfaces

# wireless
#auto wlan0
#allow-hotplug wlan0
#iface wlan0 inet manual
#iface wlan0 inet dhcp
#    wpa-ssid "Iasso's Work phone"
#    wpa-psk "iassoiasso"
#wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf
#iface default inet dhcp
#hwaddress ether f0:7b:cb:2e:a3:34


/etc/wpa_supplicant/wpa_supplicant.conf

#Needed for wpa_gui to work
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev

#Needed for wpa_gui to alter the configuration file
update_config=1

network={
 ssid="dd-wrt"
 psk="iassoiasso"
 #Protocal type can be: RSN(for WP2) and WPA(for WPA1)
 proto=WPA
 #Key managment type can be: WPA-PSK or WPA-EAP (Pre-Shared or Enterprise)
 key_mgmt=WPA-PSK
 #Pairwise can be CMMP or TKIP(for WPA2 or WPA1)
 pairwise=TKIP
 #Authorization option should be OPEN for both WPA1/WPA2 (in less commonly used are SHARED and LEAP)
 auth_alg=OPEN
}
#ctrl_interface=/var/run/wpa_supplicant
#ap_scan=2

#network={
#       ssid="skynet"
#       scan_ssid=1
#       proto=WPA RSN
#       key_mgmt=WPA-PSK
#       pairwise=CCMP TKIP
#       group=CCMP TKIP
#       psk="WD43388AA34701A"
#}




