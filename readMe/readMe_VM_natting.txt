The vmware network config should have 3 adapters, VMnet0, VMnet1 and VMnet8. 
Configure VMnet0:
1. Under "VMnet information", select Bridged
2. Click "Automatic settings..." when the dialog appears unselect your wireless  and the Juniper adpater.

Configure VMnet1:
1. Under "VMnet information", select Host-Only
2. Select both checkboxes ("Connect a host virtual...." and "Use local DHCP...").
3. You can modify the subnet, if you want.

Configure VMnet8:
1. Under "VMnet information", select NAT
2. Select both checkboxes ("Connect a host virtual...." and "Use local DHCP...").
3. You can modify the subnet, if you want.

The MAC addresses for the virtual adapters need to be changed.
1. Open the virtual machine seetings (on the toolbar in workstation VM -> settings, on the toolbar in vmplayer Virtual Machine -> Virtual Machine Settings...)
2. Repeat the following stop for each "Network Adapter".
3. Click on "Network Adapter"
4. Click on the "Advanced" button.
5. Click the "Generate" button for the "MAC Address"
6. Click "OK"
If you have started the VM prior to the above steps, you should shutdown the VM and reboot the PC.  The VM and virtual adapters can get out of sync.

for the ISA proxy service:
Download cntlm_0.92.3_amd64.deb
sudo dpkg -i cntlm_0.92.3_amd64.deb

you will need to modify the cntlm.conf as root. An example is in Appendix A. You will need to update the PassNTLMv2 parameter.

Execute the following.
sudo invoke-rc.d cntlm stop
cntlm -I -M http://google.com
Enter password.

Copy PassNTLMv2 value into cntlm.conf.
Execute the following.
sudo invoke-rc.d cntlm start

The above will have to be repeated every time you change your windows password.

Proxy setup for machine:

in .bashrc in your home dir.
https_proxy="http://127.0.0.1:3128"
http_proxy=$https_proxy
ftp_proxy=$https_proxy

in system settings:
Start -> Settings -> System Settings
Click 'Network Settings'
Click 'Proxy'
Select 'Manually specify the proxy settings'
Click 'Setup' to the right of 'Manually specify the proxy settings'
Check 'Use the same proxy server for all protocols'
Next to HTTP, add 'http://127.0.0.1' (no quotes), then add '3128' (no quotes) to the box to the far right.

If you use Firefox or Iceweasel, you will have to set the network config in the app.

in apt config:
edit (as root) 70debconf in /etc/apt/apt.conf.d
Add
Acquire::ftp::Proxy "http://127.0.0.1:3128";
Acquire::http::Proxy "http://127.0.0.1:3128";
Acquire::https::Proxy "http://127.0.0.1:3128";


#
# Cntlm Authentication Proxy Configuration
#
# NOTE: all values are parsed literally, do NOT escape spaces,
# do not quote. Use 0600 perms if you use plaintext password.
#

Username	yourUserName
Domain		us009
#Password	password
# NOTE: Use plaintext password only at your own risk
# Use hashes instead. You can use a "cntlm -M" and "cntlm -H"
# command sequence to get the right config for your environment.
# See cntlm man page
# Example secure config shown below.
# PassLM          1AD35398BE6565DDB5C4EF70C0593492
# PassNT          77B9081511704EE852F94227CF48A793

### Only for user 'testuser', domain 'corp-uk'
# PassNTLMv2      D5826E9C665C37C80B53397D5C07BBCB
PassNTLMv2      update with output of cntlm -I -M http://google.com

# Specify the netbios hostname cntlm will send to the parent
# proxies. Normally the value is auto-guessed.
#
# Workstation	netbios_hostname

# List of parent proxies to use. More proxies can be defined
# one per line in format <proxy_ip>:<proxy_port>
#
Proxy		proxyfarm-us.3dns.netz.sbs.de:84   # modify if proxy changes
Proxy		proxyfarm-fth.3dns.netz.sbs.de:84  # modify if proxy changes
#Proxy		10.0.0.41:8080
#Proxy		10.0.0.42:8080

# List addresses you do not want to pass to parent proxies
# * and ? wildcards can be used
#
#NoProxy		localhost, 127.0.0.*, 10.*, 192.168.*

# Specify the port cntlm will listen on
# You can bind cntlm to specific interface by specifying
# the appropriate IP address also in format <local_ip>:<local_port>
# Cntlm listens on 127.0.0.1:3128 by default
#
Listen		3128

# If you wish to use the SOCKS5 proxy feature as well, uncomment
# the following option. It can be used several times
# to have SOCKS5 on more than one port or on different network
# interfaces (specify explicit source address for that).
#
# WARNING: The service accepts all requests, unless you use
# SOCKS5User and make authentication mandatory. SOCKS5User
# can be used repeatedly for a whole bunch of individual accounts.
#
#SOCKS5Proxy	8010
#SOCKS5User	dave:password

# Use -M first to detect the best NTLM settings for your proxy.
# Default is to use the only secure hash, NTLMv2, but it is not
# as available as the older stuff.
#
# This example is the most universal setup known to man, but it
# uses the weakest hash ever. I won't have it's usage on my
# conscience. :) Really, try -M first.
#
Auth		NTLMv2
#Auth		LM
#Flags		0x06820000

# Enable to allow access from other computers
#
#Gateway	yes

# Useful in Gateway mode to allow/restrict certain IPs
# Specifiy individual IPs or subnets one rule per line.
#
Allow		127.0.0.1
Deny		0/0

# GFI WebMonitor-handling plugin parameters, disabled by default
#
#ISAScannerSize     1024
#ISAScannerAgent    Wget/
#ISAScannerAgent    APT-HTTP/
#ISAScannerAgent    Yum/

# Headers which should be replaced if present in the request
#
#Header		User-Agent: Mozilla/4.0 (compatible; MSIE 5.5; Windows 98)

# Tunnels mapping local port to a machine behind the proxy.
# The format is <local_port>:<remote_host>:<remote_port>
#
#Tunnel		11443:remote.com:443

