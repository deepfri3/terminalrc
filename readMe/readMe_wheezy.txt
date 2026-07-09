Install Debian Wheezy on the Dell 6530:

Created Date: 2014/01/06
Author: Robert Limlaw (robert.limlaw@siemens.com)
Last Modified: 2014/02/20 by George Baker (george.baker@siemens.com)

Currently on Debian Wheezy 7.0.3 the Wifi is not supported by the installer.  If you are installing within Diemens, installing from disks is your only option.  From home, you can install from the internet.  I installed the KDE environment under the advanced install.

We should get a disk caddy for the 6530 and get use another harddrive for data.  We should put home and var on the other disk.

This is convenience:
su to the root account and add yourself to the sudo group.
usermod -a -G sudo yourUserName

Modify the /etc/sudoers file:
From
%sudo ALL=(ALL:ALL) ALL
To
%sudo ALL=(ALL:ALL) NOPASSWD: ALL

Change username to conform to active direcory (i.e. bakerg -> BakerG):
Create a new user.
Login as that user.
su to root
killall -u old
id old
usermod -l new old
groupmod -n new old
usermod -d /home/new -m new
id new
Logout
Done

Note: you must logout and login to activate these changes.



dhcp setup:
in dhclient.conf in /etc/dhcp, modify the line
#send host-name = gethostname();

with
send host-name = "yourMachineName.us009.siemens.net";
(Note: us009 is not a mis-print, we still get our IP from us009)

cntlm for the ISA proxy service:
Download cntlm_0.92.3_amd64.deb
sudo dpkg -i cntlm_0.92.3-1_amd64.deb

you will need to modify the cntlm.conf as root. Copy example in Appendix A and update with needed info (User, Domain, Proxy, Auth, etc.).

Execute the following.
sudo service cntlm stop
sudo cntlm -I -M http://google.com
Enter password.

Copy PassNTLMv2 value into cntlm.conf.
Execute the following.
sudo invoke-rc.d cntlm start



Proxy setup for machine:
in .bashrc in ~/ dir.
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

in apt config:
edit (as root) 70debconf in /etc/apt/apt.conf.d
Add
Acquire::http::proxy "http://127.0.0.1:3128";
Acquire::https::proxy "http://127.0.0.1:3128";
Acquire::ftp::proxy "http://127.0.0.1:3128";

If you take your laptop home and want to connect to internet, we will have to modify the cntlm.conf file and other settings.
For now there isn't a better way.



Configure repositories for apt:
edit /etc/apt/sources.list
#

deb http://ftp.us.debian.org/debian/ wheezy main contrib non-free
deb-src http://ftp.us.debian.org/debian/ wheezy main contrib non-free

deb http://ftp.us.debian.org/debian/ wheezy-backports main contrib non-free
deb-src http://ftp.us.debian.org/debian/ wheezy-backports main contrib non-free

deb http://security.debian.org/ wheezy/updates main contrib non-free
deb-src http://security.debian.org/ wheezy/updates main contrib non-free

# wheezy-updates, previously known as 'volatile'
deb http://ftp.us.debian.org/debian/ wheezy-updates main contrib non-free
deb-src http://ftp.us.debian.org/debian/ wheezy-updates main contrib non-free

# firefox
deb http://packages.linuxmint.com debian import

# XLS Optional
#
# jenslody debian code::blocks repository
deb http://apt.jenslody.de/stable wheezy main
deb-src http://apt.jenslody.de/stable wheezy main
#
# wxwidgets
#deb http://apt.wxwidgets.org/ squeeze-wx main

# llvm - wheezy (Debian oldstable)
deb http://llvm.org/apt/wheezy/ llvm-toolchain-wheezy main
deb-src http://llvm.org/apt/wheezy/ llvm-toolchain-wheezy main

Run:
apt-get update

Adding public keys for repositories:
Execute:
sudo apt-get update
An error(s) occur for the public key (NO_PUBKEY), copy a key into the following command (repeat for all missing keys). I used the following key server, pgpkeys.mit.edu.

gpg --keyserver keyServer --recv-keys Xx_key_xX
gpg --export --armor Xx_key_xX | sudo apt-key add -

Example:
gpg --keyserver pgpkeys.mit.edu --recv-keys 9BDB3D89CE49EC21
gpg --export --armor 9BDB3D89CE49EC21 | sudo apt-key add -

Note: Cannot get public keys from within the Siemens network/building. That port is blocked. Must be done at home or manually

Re-run:
apt-get update

If you start getting errors with debian repositories
Example: GPG error: http://security.debian.org wheezy/updates Release: The following signatures were invalid: BADSIG 9D6D8F6BC857C906 Debian Security Archive Automatic Signing Key (8/jessie) <ftpmaster@debian.org>
Try:
sudo apt-get clean
cd /var/lib/apt
sudo mv lists lists.old
sudo mkdir -p lists/partial
sudo apt-get clean
sudo apt-get update
(http://stackoverflow.com/questions/25388620/debian-apt-error-the-following-signatures-were-invalid-nodata-1-nodata-2)

for wireless:
apt-get install linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,') broadcom-sta-dkms

for nvidia:
apt-get install -t wheezy-backports bumblebee-nvidia primus

Firefox:
apt-get install firefox flashplugin-nonfree

Mange network connections using either network manager or interfaces file
Appendix C has an example of the /etc/network/interfaces



Touchpad nightmare:
apt-get install kde-config-touchpad
apt-get install firmware-linux
apt-get install firmware-linux-nonfree

download psmouse-alps-1.3-alt.tbz from http://www.dahetral.com/public-download

extract psmouse-alps-1.3-alt.tbz to ~/mouse
mkdir ~/mouse
mv psmouse-alps-1.3.alt.tba ~/mouse
cd ~/mouse
tar -xvf psmouse-alps-1.3-alt.tbz
su
mv usr/src/psmouse-alps-1.3 /usr/src
dkms add /usr/src/psmouse-alps-1.3
dkms install /usr/src/psmouse-alps-1.3 (Note: if error occurs on this step its ok.)
reboot



SDHCI:
i don't like errors at startup

sudo echo "" >  /etc/modprobe.d/blacklist.conf
sudo echo "blacklist sdhci" >> /etc/modprobe.d/blacklist.conf
sudo echo "blacklist sdhci-pci" >> /etc/modprobe.d/blacklist.conf
sudo echo "blacklist mmc-core" >> /etc/modprobe.d/blacklist.conf
sudo echo "" >> /etc/modprobe.d/blacklist.conf

sudo update-initramfs -u

add to /etc/rc.local as root above "exit 0"
[[ $(lsmod | grep sdhci) ]] && rmmod sdhci_pci sdhci && modprobe sdhci_pci && modprobe sdhci
1sbtexi



SSH config:
Creating a RSA ssh key.
ssh-keygen -t rsa -f id_serverName_userName

This creates a public and private key.
1. id_serverName_userName     -> no ext is the private key
2. id_serverName_userName.pub -> pub is the public key

On the SSH server side.
# make directory
mkdir -p ~/.ssh
# add public key to authorized key file
cat pathTo/id_serverName_userName.pub >> ~/.ssh/authorized_keys
# sets permissions
chmod 0640 ~/.ssh/authorized_keys
chmod 0700 ~/.ssh

On the SSH client side:
# make directory
mkdir -p ~/.ssh

create a file named config with the following

Host profileName
  User userName
  HostName serverName
  IdentityFile ~/.ssh/id_serverName_userName

Example:
Host agentsmith
  User BakerG
  HostName AgentSmith.us009.siemens.net
  IdentityFile ~/.ssh/id_agentsmith_bakerg_sbtusfhp2736ws

# add config file
mv pathTo/config ~/.ssh/
# add private key
mv pathTo/id_serverName_userName ~/.ssh/
# sets permissions
chmod 0600 ~/.ssh/config
chmod 0400 ~/.ssh/id_serverName_userName
chmod 0700 ~/.ssh



Samba config:
sudo apt-get install libsmbclient libwbclient0 samba samba-common samba-common-bin smbclient winbind

Copy the smb.conf from Appendix B to /etc/samba

Initial install assumes that you are connected to internet.



Packages for bitbake:
You can install them seperately.
apt-get update
apt-get install sed wget cvs subversion git-core coreutils unzip texi2html texinfo docbook-utils \
   gawk python-pysqlite2 diffstat help2man make gcc build-essential g++ chrpath libtool makeself \
   desktop-file-utils libncurses5 curl bison bc python python-ply python-progressbar patch \
   m4 perl libpcre3-dev libc6-dev libsdl1.2-dev qemu libxml2-utils xmlto quilt genext2fs \
   uboot-mkimage cifs-utils



Multi-arch support:

sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install ia32-libs-gtk



CodeSourcery Install:

Change default shell (/bin/sh) to use bash:
By default debian wheezy uses dash shell instead of bash shell.
Run this command:
sudo dpkg-reconfigure dash.
A dialog will pop-up. right-arrow over to 'No' and hit enter.

download the IA32 GNU/Linux Installer (version 2010.09-50).

Link as 2014/02/20:
http://www.mentor.com/embedded-software/sourcery-tools/sourcery-codebench/lite/?cmpid=7108&lite=arm&target_os=GNU%2FLinux&target_arch=ARM&returnURL=https%253A%252F%252Fsourcery.mentor.com%252FGNUToolchain%252Frelease1600%253Flite%253Darm%2526cmpid%253D7108
Download Lite Edition
Fill out the form and mentor graphics will send email with download link

Traverse to the directory where 'arm-2010.09-50-arm-none-linux-gnueabi.bin'
resides. In a shell, execute
>/bin/sh arm-2010.09-50-arm-none-linux-gnueabi.bin

A GUI should appear. Follow the instructions:
1.  Click 'Next'
2.  Accept license and click 'Next'
3.  Click 'Next'
4.  Select Custom and click 'Next'
5.  Unselect documentation and click 'Next'
6.  Specify direcotry or leave the default and click 'Next'
7.  Select 'Do not modify PATH' and click 'Next'
8.  Select 'Don't create link' and click 'Next'
9.  Click 'Install'
10. Click 'Done'

Install toolchain in /opt.
Traverse to the CodeSourcery Install directory. Default is
   ~/CodeSourcery/Sourcery_G++_Lite
sudo mkdir -p /opt/arm-2010.09
sudo cp -r arm-none-linux-gnueabi /opt/arm-2010.09/
sudo cp -r bin /opt/arm-2010.09/
sudo cp -r lib /opt/arm-2010.09/
sudo cp -r libexec /opt/arm-2010.09/
sudo cp -r share /opt/arm-2010.09/
cd
rm -rf ~/CodeSourcery

Compiler installation complete.

XLS Specific Library:

Good path as of 2014/02/20:
\\usfpksrv04\public\PMISoftware\PMI2tools\Sourcery\codesourcery_xls.tar.bz2

Copy XLS specific libraries onto VM/machine to recommended path.
1. sudo mkdir /opt/XLS (you can use any path desireable)
2. sudo cp codesourcery_xls.tar.bz2 /opt/XLS
3. cd /opt/XLS
4. sudo tar xjf codesourcery_xls.tar.bz2

Configure CodeBlocks compiler settings.
1. On menu, Settings -> Compiler.
2. Select "GNU ARM GCC Compiler" at top of dialog.
3. Select "Toolchain executables" tab.
4. Set "Compiler's installation directory" to "/opt/arm-2010.09/bin".
5. Set "Debugger" to "GDB/CDB debugger : Default" (someone needs to verify this step).
6. Select "Search directories" tab.
7. On "Search directories" tab, Select "Compiler" tab.
8. Add "/opt/arm-2010.09/arm-none-linux-gnueabi/libc/usr/include" directory (this may not be needed).
9. Add "/opt/XLS/usr/include" directory.
A. On "Search directories" tab, Select "Linker" tab.
B. Add "/opt/arm-2010.09/arm-none-linux-gnueabi/libc/usr/lib" directory (this may not be needed).
C. Add "/opt/XLS/usr/lib" directory.
D. Click "OK".


ClearCase full client install:

Packages that need to be installed ClearCase:
sudo apt-get install ia32-libs-gtk

The ibm installer works with firefox and not iceweasel, so install firefox.
sudo apt-get install firefox

Install  IBM Installation Manager:
export BROWSER=/usr/bin/firefox
Copy the installation manager sources onto the machine
* You can download the latest installation manager from IBM Support
** As of this writing the latest version is 1.7.2.0

64-bit Linux:
cd IM_Installer/Linux_x64
or
32-bit Linux:
cd IM_Installer/Linux_x86

Change to root and keep preserver your environment with '-p'
su -p
./install
Follow the instructions to install.
Right click on the KDE start menu and click 'Menu Editor'.
Select 'IBM Installation Manager' -> 'IBM Installation Manager' and select the 'Advanced' tab.
Check the 'Run as a different user' and enter 'root' as the 'username'.
Click 'Save' and exit.

Copy the clearcase 8.0.1.x sources  onto the machine.

Note: make sure 'rpm' is installed prior to installation.
rpm --version -> installed if "RPM version x.xx.x" is printed to the console

Run IBM Installation manager
On the installation manager, click 'File -> Preferences'.
Navigate to 'Internet -> HTTP Proxy'. Check "Enable proxy server".
Add '127.0.0.1' to Proxy host.
Add '3128' to Proxy port.
Navigate to 'Repositories' and click 'Add Repository'.
Click 'Browse' and select 'repository.config' in the directory where tyou copied the clearcase 8.0.1.x sources.
Click 'OK' until you are back to the main page.
Click 'Install'.

The installation manager may need to be updated, so update it.
Follow the instructions and add the following where needed.
License host:    27000@bt-licserver01.hqs.sbt.siemens.com
Registry host:   usfhp00001esrv.ww009.siemens.net
Registry region: bt_fhp01_x

If you see this error during "install" phase:
   Action GskitAction (install /opt/ibm/RationalSDLC) failed:
   java.io.IOException: Exit status -1 from command: rpm -Uv --nodeps --ignorearch --force --prefix /opt gskcrypt32-8.0.50.10.linux.x86.rpm
This means that rpm is not installed.
Run:
sudo apt-get install rpm
Then re-run installation

Compile the MVFS manually (if it fails during installation):
cd /var/adm/rational/clearcase/mvfs/mvfs_src
edit mvfs_param.mk.config
add
RATL_EXTRAFLAGS := -DRATL_EXTRA_VER=0 -DRATL_COMPAT32 -m64
save
sudo make cleano
sudo make
sudo make install

Setting up rcleartool:
cd /opt/ibm/RationalSDLC/clearcase/RemoteClient
sudo ./rcleartool
./rcleartool
exit
cd /usr/local/bin
sudo ln -s /opt/ibm/RationalSDLC/clearcase/RemoteClient/rcleartool rcleartool

Create clearcase groups and add users:
su root
groupadd USFHP-CC_EngDefault-U
groupadd USFHP-CC_FS20-U
groupadd USFHP-CC_MNS-U
groupadd USFHP-CC_HW-U
groupadd USFHP-CC_XLS-U
groupadd USFHP-CC_XLS_PNB-U
groupadd SBT-CCCCP-MEM
adduser $USER USFHP-CC_EngDefault-U
adduser $USER USFHP-CC_FS20-U
adduser $USER USFHP-CC_MNS-U
adduser $USER USFHP-CC_HW-U
adduser $USER USFHP-CC_XLS-U
adduser $USER USFHP-CC_XLS_PNB-U
adduser $USER SBT-CCCCP-MEM
usermod -g USFHP-CC_EngDefault-U $USER
id
The user should now be part of all the CC groups.
Note: If the user is you, remember to sign out and sign in.

create file 'flexlm_host' in /var/adm/atria/config

Add this file:
# ==================================================================
#  License Host File Template for:
#
#     IBM Rational Common Licensing (powered by FLEXlm software)
#
#
#  The license host file specifies the license server
#  from which this computer will acquire Rational Common
#  Licensing licenses. To change the license server host
#  used by this computer:
#
#  1: Make a copy of this template in a temporary location.
#
#  2: In the copy, replace "hostname" in the first
#     uncommented line below with the host name or
#     IP address of the Rational Common Licensing
#     license server host.
#
#  3: Copy the edited template to:
#
#       /var/adm/rational/clearcase/config/flexlm_host
#
#  After the edited template has been copied, all Rational
#  Common Licensing license requests will be routed to
#  the new server.
#
# ==================================================================

#SERVER 27000@bt-licserver01.hqs.sbt.siemens.com ANY
SERVER 27000@bt-licserver01.siemens.net:27000@rational-lic-debwg02.siemens.net:27000@rational-lic-debwg03.siemens.net
USE_SERVER

Start clearcase service:
sudo /usr/atria/etc/clearcase

Mount clearcase triggers:
sudo mkdir /var/adm/triggers
create script with the following
mount -t cifs //usfhp00001esrv.ww009.siemens.net/Triggers /var/adm/triggers -o credentials=/home/$USER/.smbcredentials,rw,gid=disk
run script
sudo ./scriptName

Set group list for rcleartool:
rcleartool set -pref CLEARCASE_GROUP_PRIMARY -val "ww009\USFHP-CC_EngDefault-U"
rcleartool set -pref CLEARCASE_GROUP_LIST -val "ww009\USFHP-CC_EngDefault-U;ww009\USFHP-CC_EngDefault-U;ww009\USFHP-CC_FS20-U;ww009\USFHP-CC_MNS-U;ww009\USFHP-CC_HW-U;ww009\USFHP-CC_XLS-U;ww009\USFHP-CC_XLS_PNB-U;ww002\SBT-CCCCP-MEM"
rcleartool set -pref SERVER_URL -val https://usfhp00001esrv.ww009.siemens.net/ccrc
rcleartool set -pref NON_LATEST_CHECKOUT -val LATEST

VMWare Workstation Install:

Copy the Linux x86_64 version to the machine.
sudo ./VMWare-Workstation-Full-xxx.bundle
Follow instructions and then update.

Installing vmware can sometimes cause issues with the USB init scripts
Issue described here: https://communities.vmware.com/thread/337769

Make sure that this file:
/etc/init.d/vmware-USBArbitrator

Has something like this in near the top:
### BEGIN INIT INFO
# Provides:          scriptname
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start daemon at boot time
# Description:       Enable service provided by daemon.
### END INIT INFO

If not add this to the top

More information on this topic:
https://wiki.debian.org/LSBInitScripts



How to Setup TFTP server:
http://askubuntu.com/questions/201505/how-do-i-install-and-run-a-tftp-server
http://mohammadthalif.wordpress.com/2010/03/05/installing-and-testing-tftpd-in-ubuntudebian/

1. Install following packages.
sudo apt-get install xinetd tftpd tftp

2. Make your tftpboot directory:
Make it wherever you want, but for this example lets make it in your home directory
mkdir ~/tftpboot
sudo chmod -R 777 ~/tftpboot
sudo chown nobody:nogroup -R ~/tftpboot
Example:
ls -la ~/tftpboot
drwxrwxrx  2 nobody nogroup   4096 May 31 09:58 tftpboot

3. Create /etc/xinetd.d/tftp (config file)
sudo vi /etc/xinetd.d/tftp
put this entry:
service tftp
{
protocol = udp
port = 69
socket_type = dgram
wait = yes
user = nobody
server = -c -s /usr/sbin/in.tftpd
server_args = /home/bakerg/tftpboot #(use your tftpboot directory location)
disable = no
}

4. Restart the xinetd service.
sudo /etc/init.d/xinetd restart

Now our tftp server is up and running.


Appendix A:

The cntlm.conf file,

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
Proxy           proxyfarm-na.inac.siemens.net:84

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


Appendix B:

The smb.conf file,

#
# Sample configuration file for the Samba suite for Debian GNU/Linux.
#
#
# This is the main Samba configuration file. You should read the
# smb.conf(5) manual page in order to understand the options listed
# here. Samba has a huge number of configurable options most of which
# are not shown in this example
#
# Some options that are often worth tuning have been included as
# commented-out examples in this file.
#  - When such options are commented with ";", the proposed setting
#    differs from the default Samba behaviour
#  - When commented with "#", the proposed setting is the default
#    behaviour of Samba but the option is considered important
#    enough to be mentioned here
#
# NOTE: Whenever you modify this file you should run the command
# "testparm" to check that you have not made any basic syntactic
# errors.
# A well-established practice is to name the original file
# "smb.conf.master" and create the "real" config file with
# testparm -s smb.conf.master >smb.conf
# This minimizes the size of the really used smb.conf file
# which, according to the Samba Team, impacts performance
# However, use this with caution if your smb.conf file contains nested
# "include" statements. See Debian bug #483187 for a case
# where using a master file is not a good idea.
#

#======================= Global Settings =======================

[global]

## Browsing/Identification ###

# Change this to the workgroup/NT-domain name your Samba server will part of


# server string is the equivalent of the NT Description field


# Windows Internet Name Serving Support Section:
# WINS Support - Tells the NMBD component of Samba to enable its WINS Server
;   wins support = no
   wins support = no

# WINS Server - Tells the NMBD components of Samba to be a WINS Client
# Note: Samba can be either a WINS Server, or a WINS Client, but NOT both
;   wins server = w.x.y.z

# This will prevent nmbd to search for NetBIOS names through DNS.
   dns proxy = yes

# What naming service and in what order should we use to resolve host names
# to IP addresses
;   name resolve order = lmhosts host wins bcast
   name resolve order = host wins bcast

# For outlook - uses ntlm authentication, but cntln uses ntlmv2
client ntlmv2 auth = no

#### Networking ####

# The specific set of interfaces / networks to bind to
# This can be either the interface name or an IP address/netmask;
# interface names are normally preferred
;   interfaces = 127.0.0.0/8 eth0

# Only bind to the named interfaces and/or networks; you must use the
# 'interfaces' option above to use this.
# It is recommended that you enable this feature if your Samba machine is
# not protected by a firewall or is a firewall itself.  However, this
# option cannot handle dynamic or non-broadcast interfaces correctly.
;   bind interfaces only = yes



#### Debugging/Accounting ####

# This tells Samba to use a separate log file for each machine
# that connects
   log file = /var/log/samba/log.%m

# Cap the size of the individual log files (in KiB).
   max log size = 1000

# If you want Samba to only log through syslog then set the following
# parameter to 'yes'.
#   syslog only = no

# We want Samba to log a minimum amount of information to syslog. Everything
# should go to /var/log/samba/log.{smbd,nmbd} instead. If you want to log
# through syslog you should set the following parameter to something higher.
   syslog = 0

# Do something sensible when Samba crashes: mail the admin a backtrace
   panic action = /usr/share/samba/panic-action %d


####### Authentication #######

# "security = user" is always a good idea. This will require a Unix account
# in this server for every user accessing the server. See
# /usr/share/doc/samba-doc/htmldocs/Samba3-HOWTO/ServerType.html
# in the samba-doc package for details.
   security = user

# You may wish to use password encryption.  See the section on
# 'encrypt passwords' in the smb.conf(5) manpage before enabling.
   encrypt passwords = true

# If you are using encrypted passwords, Samba will need to know what
# password database type you are using.
   passdb backend = tdbsam

   obey pam restrictions = yes

# disable guest account
   restrict anonymous = 2

# This boolean parameter controls whether Samba attempts to sync the Unix
# password with the SMB password when the encrypted SMB password in the
# passdb is changed.
   unix password sync = yes

# For Unix password sync to work on a Debian GNU/Linux system, the following
# parameters must be set (thanks to Ian Kahan <<kahan@informatik.tu-muenchen.de> for
# sending the correct chat script for the passwd program in Debian Sarge).
   passwd program = /usr/bin/passwd %u
   passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .

# This boolean controls whether PAM will be used for password changes
# when requested by an SMB client instead of the program listed in
# 'passwd program'. The default is 'no'.
   pam password change = yes

########## Domains ###########

# Is this machine able to authenticate users. Both PDC and BDC
# must have this setting enabled. If you are the BDC you must
# change the 'domain master' setting to no
#
;   domain logons = yes
#
# The following setting only takes effect if 'domain logons' is set
# It specifies the location of the user's profile directory
# from the client point of view)
# The following required a [profiles] share to be setup on the
# samba server (see below)
;   logon path = \\%N\profiles\%U
# Another common choice is storing the profile in the user's home directory
# (this is Samba's default)
#   logon path = \\%N\%U\profile

# The following setting only takes effect if 'domain logons' is set
# It specifies the location of a user's home directory (from the client
# point of view)
;   logon drive = H:
#   logon home = \\%N\%U

# The following setting only takes effect if 'domain logons' is set
# It specifies the script to run during logon. The script must be stored
# in the [netlogon] share
# NOTE: Must be store in 'DOS' file format convention
;   logon script = logon.cmd

# This allows Unix users to be created on the domain controller via the SAMR
# RPC pipe.  The example command creates a user account with a disabled Unix
# password; please adapt to your needs
; add user script = /usr/sbin/adduser --quiet --disabled-password --gecos "" %u

# This allows machine accounts to be created on the domain controller via the
# SAMR RPC pipe.
# The following assumes a "machines" group exists on the system
; add machine script  = /usr/sbin/useradd -g machines -c "%u machine account" -d /var/lib/samba -s /bin/false %u

# This allows Unix groups to be created on the domain controller via the SAMR
# RPC pipe.
; add group script = /usr/sbin/addgroup --force-badname %g

########## Printing ##########

# If you want to automatically load your printer list rather
# than setting them up individually then you'll need this
#   load printers = yes

# lpr(ng) printing. You may wish to override the location of the
# printcap file
;   printing = bsd
;   printcap name = /etc/printcap

# CUPS printing.  See also the cupsaddsmb(8) manpage in the
# cupsys-client package.
;   printing = cups
;   printcap name = cups

############ Misc ############

# Using the following line enables you to customise your configuration
# on a per machine basis. The %m gets replaced with the netbios name
# of the machine that is connecting
;   include = /home/samba/etc/smb.conf.%m

# Most people will find that this option gives better performance.
# See smb.conf(5) and /usr/share/doc/samba-doc/htmldocs/Samba3-HOWTO/speed.html
# for details
# You may want to add the following on a Linux system:
#         SO_RCVBUF=8192 SO_SNDBUF=8192
#   socket options = TCP_NODELAY

# The following parameter is useful only if you have the linpopup package
# installed. The samba maintainer and the linpopup maintainer are
# working to ease installation and configuration of linpopup and samba.
;   message command = /bin/sh -c '/usr/bin/linpopup "%f" "%m" %s; rm %s' &

# Domain Master specifies Samba to be the Domain Master Browser. If this
# machine will be configured as a BDC (a secondary logon server), you
# must set this to 'no'; otherwise, the default behavior is recommended.
#   domain master = auto

# Some defaults for winbind (make sure you're not using the ranges
# for something else.)
;   idmap uid = 10000-20000
;   idmap gid = 10000-20000
;   template shell = /bin/bash

# The following was the default behaviour in sarge,
# but samba upstream reverted the default because it might induce
# performance issues in large organizations.
# See Debian bug #368251 for some of the consequences of *not*
# having this setting and smb.conf(5) for details.
;   winbind enum groups = yes
;   winbind enum users = yes

# Setup usershare options to enable non-root users to share folders
# with the net usershare command.

# Maximum number of usershare. 0 (default) means that usershare is disabled.
;   usershare max shares = 100

#======================= Share Definitions =======================

[homes]
   comment = Home Directories
   browseable = no

# By default, the home directories are exported read-only. Change the
# next parameter to 'no' if you want to be able to write to them.
   read only = yes

# File creation mask is set to 0700 for security reasons. If you want to
# create files with group=rw permissions, set next parameter to 0775.
   create mask = 0700

# Directory creation mask is set to 0700 for security reasons. If you want to
# create dirs. with group=rw permissions, set next parameter to 0775.
   directory mask = 0700

# By default, \\server\username shares can be connected to by anyone
# with access to the samba server.
# The following parameter makes sure that only "username" can connect
# to \\server\username
# This might need tweaking when using external authentication schemes
   valid users = %S

# Un-comment the following and create the netlogon directory for Domain Logons
# (you need to configure Samba to act as a domain controller too.)
;[netlogon]
;   comment = Network Logon Service
;   path = /home/samba/netlogon
;   guest ok = yes
;   read only = yes

# Un-comment the following and create the profiles directory to store
# users profiles (see the "logon path" option above)
# (you need to configure Samba to act as a domain controller too.)
# The path below should be writable by all users so that their
# profile directory may be created the first time they log on
;[profiles]
;   comment = Users profiles
;   path = /home/samba/profiles
;   guest ok = no
;   browseable = no
;   create mask = 0600
;   directory mask = 0700

[printers]
   comment = All Printers
   browseable = no
   path = /var/spool/samba
   printable = yes
   guest ok = no
   read only = yes
   create mask = 0700

# Windows clients look for this share name as a source of downloadable
# printer drivers
[print$]
   comment = Printer Drivers
   path = /var/lib/samba/printers
   browseable = no
   read only = yes
   guest ok = no
# Uncomment to allow remote administration of Windows print drivers.
# You may need to replace 'lpadmin' with the name of the group your
# admin users are members of.
# Please note that you also need to set appropriate Unix permissions
# to the drivers directory for these users to have write rights in it
;   write list = root, @lpadmin


[ipc$]
   host allow = 127.0.0.1
   host deny = 0.0.0.0/0

# A sample share for sharing your CD-ROM with others.
;[cdrom]
;   comment = Samba server's CD-ROM
;   read only = yes
;   locking = no
;   path = /cdrom
;   guest ok = yes

# The next two parameters show how to auto-mount a CD-ROM when the
#	cdrom share is accesed. For this to work /etc/fstab must contain
#	an entry like this:
#
#       /dev/scd0   /cdrom  iso9660 defaults,noauto,ro,user   0 0
#
# The CD-ROM gets unmounted automatically after the connection to the
#
# If you don't want to use auto-mounting/unmounting make sure the CD
#	is mounted on /cdrom
#
;   preexec = /bin/mount /cdrom
;   postexec = /bin/umount /cdrom

Appendix C: /etc/network/interfaces file for managing network connections

# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
auto lo
iface lo inet loopback

# Main PC NIC
auto eth0
#NetworkManager
iface eth0 inet dhcp

# USB-to-ETH connection
#auto eth1
allow-hotplug eth1
#NetworkManager
iface eth1 inet static
#hwaddress ether 00:50:b6:4d:18:c4
address 192.168.251.1
netmask 255.255.255.0
#network 192.168.251.0
broadcast 192.168.251.255

# wireless
#iface wlan0 inet dhcp
#    wpa-ssid [your_ssid]
#    wpa-psk [your_wpa_password]
#hwaddress ether f0:7b:cb:2e:a3:34
