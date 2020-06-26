Install Debian Squeeze:
These are engineering instructions and not extremely detailed. If you are unfamiliar with managing PCs or installing OSes, these instructions are not for you. You have been warned.

Currently on Debian Squeeze 6.0.6 the NIC is not supported by the installer, so install OS from disks for now. After OS is installed, see appendix A for Ethernet card driver install. Install the KDE environment because the instructions below require it.

There are 2 2TB disks. I have chosen to install the OS on 1 disk and make the other /home2. Use ext4 for the filesystem. Make sure the root partition is ~100 Gb.

This is convenience:
su to the root account.
apt-get install synaptic kdeadmin
You will have to insert the correct CD.

Run kuser and add yourself to the sudo group (if you do not know what this means, you shouldn't be doing this).
Modify the sudoers file:
From
%sudo ALL=(ALL) ALL
To
%sudo ALL=(ALL) NOPASSWD: ALL


Make Ethernet driver for T420 for Debian Squeeze:
Download the 5720 driver (tg3 in linux) from Broadcom. The 5720 is a newer card and Debian Squeeze installer doesn't have it.

Add needed packages.
sudo apt-get install make gcc linux-headers-$(uname -r)* build-essentials

unzip and traverse to the ./Server/Linux/Driver
tar xzf tg3-*.tar.gz (name may vary depending on version)
cd tg3-* (directory name may vary depending on version)

edit Makefile and uncomment
TG3_EXTRA_DEFS += TG3_NO_EEE

Then
make
sudo make install
reboot


cntlm for the ISA proxy service:
Download cntlm_0.92.3_amd64.deb
sudo dpkg -i cntlm_0.92.3_amd64.deb

you will need to modify the cntlm.conf as root. Copy example in Appendix A and update with needed info.

Execute the following.
sudo invoke-rc.d cntlm stop
cntlm -I -M http://google.com
Enter password.

Copy PassNTLMv2 value into cntlm.conf.
Execute the following.
sudo invoke-rc.d cntlm start

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

in apt config:
edit (as root) 70debconf in /etc/apt/apt.conf.d
Add
Acquire::ftp::Proxy "http://127.0.0.1:3128";
Acquire::http::Proxy "http://127.0.0.1:3128";
Acquire::https::Proxy "http://127.0.0.1:3128";


Configure repositories for Synaptic:
Start -> Settings -> Software Sources
Next to 'Download from:', select 'Server  for the United States'
Check all checkboxes on this tab.
Select 'Third-Party Software' tab, remove all cdrom entries and check all remaining entries.
Click 'Add', and enter 'deb http://ppa.launchpad.net/mozillateam/firefox-next/ubuntu lucid main'
Click 'Add', and enter 'deb http://pkg.jenkins-ci.org/debian binary/'
Click 'Close'

Adding public keys for repositories:
Execute:
sudo apt-get update
An error(s) occur for the public key (NO_PUBKEY), copy a key into the following command (repeat for all missing keys). I used the following key server, wwwkeys.cz.pgp.net.

gpg --keyserver keyServer --recv-keys Xx_key_xX
gpg --export --armor Xx_key_xX | sudo apt-key add -

Example:
gpg --keyserver wwwkeys.cz.pgp.net --recv-keys 9BDB3D89CE49EC21
gpg --export --armor 9BDB3D89CE49EC21 | sudo apt-key add -


Samba config:
sudo apt-get install libsmbclient libwbclient0 samba samba-common samba-common-bin smbclient winbind

Copy the smb.conf from Appendix B to /etc/samba


Initial install assumes that you are connected to internet.

Debian by default shell is Dash. This reconfigures to bash.
dpkg-reconfigure dash
answer no

Packages added for sound:
apt-get install alsa-base alsa-oss alsa-utils alsamixergui alsaplayer-alsa \
  alsaplayer-gtk alsaplayer-jack libasound2

Packages for bitbake:
You can install them seperately.
apt-get update
apt-get install sed wget cvs subversion git-core coreutils unzip texi2html texinfo docbook-utils \
   gawk python-pysqlite2 diffstat help2man make gcc build-essential g++ chrpath libtool makeself \
   desktop-file-utils zlib libncurses5 curl bison bc python python-ply python-progressbar patch \
   m4 perl libpcre3-dev libc6-dev libsdl1.2-dev qemu libxml2-utils xmlto apr quilt genext2fs \
   uboot-mkimage


CodeSourcery Install:

download the IA32 GNU/Linux Installer (version 2010.09-50).
https://sourcery.mentor.com/GNUToolchain/release1600

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
1. Traverse to the CodeSourcery Install directory. Default is
   ~/CodeSourcery/Sourcery_G++_Lite
2. sudo mkdir -p /opt/arm-2010.09
3. sudo cp -r arm-none-linux-gnueabi /opt/arm-2010.09/
4. sudo cp -r bin /opt/arm-2010.09/
5. sudo cp -r lib /opt/arm-2010.09/
6. sudo cp -r libexec /opt/arm-2010.09/
7. sudo cp -r share /opt/arm-2010.09/
8. rm -rf ~/CodeSourcery

Compiler installation complete.


ClearCase full client install:

Packages that need to be installed ClearCase:
sudo apt-get install ia32-libs-gtk

The ibm installer works with firefox and not iceweasel, so install firefox.
sudo apt-get install firefox

Note: You will have to install IBM Clearcase Remote Client 7.x.x prior to the full client. The Installation Manager from the Remote Client is self contained and will install without issue.

Directions for Clearcase Remote Client 7.x.x:
Copy RATL_Clearcase_Remote_Client.zip onto the machine and unzip.

export BROWSER=/usr/bin/firefox
cd disk1/Installerimage_linux
su -p
./install

Follow the instructions to install.
After Remote Client 7.x.x is installed, close the Installation Manager.
Right click on the KDE start menu and click 'Menu Editor'.
Select 'IBM Installation Manager' -> 'IBM Installation Manager' and select the 'Advanced' tab.
Check the 'Run as a different user' and enter 'root' as the 'username'.
Click 'Save' and exit.

Delete the directory created (disk1) to install the Remote Client.
From the start menu, click 'IBM Installation Manager' -> 'IBM Installation Manager' and enter root's password.
Click 'Uninstall' and uninstall the Remote Client.

Copy RATL_CLEARCASE_8.0_LINUX-X86_ML.zip and 8.0.0.3-Rational-RCC-linux_x86-FP03.zip onto the machine.
unzip RATL_CLEARCASE_8.0_LINUX-X86_ML.zip

On the installation manager, click 'File -> Preferences'.
The installation manager may need to be updated, so update it.
Select 'Repositories' and click 'Add Repository'.
Click 'Browse' and select 'diskTag.inf' in the directory where you unzipped the RATL_CLEARCASE_8.0_LINUX-X86_ML.zip (disk1).
Click 'OK' until you are back to the main page.
Click 'Install'.

Follow the instructions and add the following where needed.
License host:    27000@bt-licserver01.hqs.sbt.siemens.com
Registry host:   usfhp000001clc.us009.siemens.net
Registry region: bt_fhp01_x

Restart installation manager.
Copy 8.0.0.3-Rational-RCC-linux_x86-FP03.zip onto the machine and unzip into disk2.
On the installation manager, click 'File -> Preferences'.
Select 'Repositories' and click 'Add Repository'.
Click 'Browse' and select 'repository.config' in the directory where you unzipped the 8.0.0.3-Rational-RCC-linux_x86-FP03.zip (disk2).
Click 'OK' until you are back to the main page.
Click 'Update'.

Compile the MVFS:
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


Install Quartus:
Download the Quartus II Subscription Edition version 10.1 (10.1_quartus_linux.sh, 10.1_devices_linux.sh and 10.1sp1_quartus_linux.sh).
Order is important:
sudo mkdir /opt/quartus_10.1
sudo chmod 0777 /opt/
sudo chmod 0777 /opt/quartus_10.1

chmod 0555 10.1*
./10.1_quartus_linux.sh --nox11 --confirm
Follow instructions and install in the directory (/opt/quartus_10.1).
Insert 1800@usfhp00eng0001 (ask Tom, I forget server name)

./10.1_quartus_linux.sh --nox11 --confirm
Follow instructions and install in the directory (/opt/quartus_10.1).
Only add these devices:
Cyclone Family
Cyclone II Family
Cyclone III/III LS Families
Cyclone IV E Family
Cyclone IV GX Family
Legacy Families
MAX II Families
MAX V Family

./10.1sp1_quartus_linux.sh --nox11 --confirm
Follow instructions and install in the directory (/opt/quartus_10.1).

Download the Nios II Embedded Design Suite version 10.1 (10.1_nios2eds_linux.sh and 10.1sp1_nios2eds_linux.sh).
chmod 0555 10.1*
./10.1_nios2eds_linux.sh --nox11 --confirm
Follow instructions and install in the directory (/opt/quartus_10.1).

./10.1sp1_nios2eds_linux.sh --nox11 --confirm
Follow instructions and install in the directory (/opt/quartus_10.1).

sudo chmod 0755 /opt/
sudo chmod 0755 /opt/quartus_10.1

sudo chown -R root /opt/quartus_10.1
sudo chgrp -R root /opt/quartus_10.1


CodeWarrior CAN compiler:

Download the FreeScale CodeWarrior 10.2 package (CW_MCU_v10.2_Eval.tar)

mkdir FreeScale
cp path/CW_MCU_v10.2_Eval.tar path/FreeScale
tar xf CW_MCU_v10.2_Eval.tar
cd path/FreeScale/disk1

Promote yourself to root.
./setuplinux -console

Follow instructions and make the install directory (/opt/CodeWarrior_MCU_10.2)


Lattice Diamond CPLD compiler:

Download the Lattice diamond 2.1 Linux x86_64 package (alien diamond_2_1-base_x64-103-x86_64-linux.rpm)

The rpm file needs to be converted to deb (alien can do this)
sudo apt-get install alien
alien diamond_2_1-base_x64-103-x86_64-linux.rpm

The output is.
diamond-2-1-base-x64_2.1-104_amd64.deb

Install the compiler.
sudo dpkg -i diamond-2-1-base-x64_2.1-104_amd64.deb


VMWare Workstation Install:
Copy the Linux x86_64 version to the machine.
sudo ./VMWare-Workstation-Full-xxx.bundle
Follow instructions and then update.


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

On the SSH client side.
# make directory
mkdir -p ~/.ssh

creat a file named config with the following.

Host serverName
  User userName
  HostName serverName
  IdentityFile ~/.ssh/id_serverName_userName

# add config file
mv pathTo/config ~/.ssh/
# add private key
mv pathTo/id_serverName_userName ~/.ssh/
# sets permissions
chmod 0600 ~/.ssh/config
chmod 0400 ~/.ssh/id_serverName_userName
chmod 0700 ~/.ssh




jenkins:
sudo apt-get install jenkins

Allows users to add and execute scripts. It is a permission thing.
sudo chown -R LimlawR:P-USFHP-EngDefault_ClearCase-U /var/lib/jenkins/
sudo chown -R LimlawR:P-USFHP-EngDefault_ClearCase-U /var/run/jenkins/

Making Jenkins secure:

Create a keystore for Jenkins.

> keytool -genkey -keyalg RSA -alias selfsigned -keystore keystore.jks -storepass changeme -validity 365 -keysize 2048
What is your first and last name?
  [Unknown]:  sauron.us009.siemens.net:50443
What is the name of your organizational unit?
  [Unknown]:  FS20_Voice
What is the name of your organization?
  [Unknown]:  Development
What is the name of your City or Locality?
  [Unknown]:  Florham Park
What is the name of your State or Province?
  [Unknown]:  NJ
What is the two-letter country code for this unit?
  [Unknown]:  US
Is CN=sauron.us009.siemens.net:50443, OU=FS20_Voice, O=Development, L=Florham Park, ST=NJ, C=US correct?
  [no]:  yes

Enter key password for <selfsigned>
        (RETURN if same as keystore password):changeme
Re-enter new password:changeme

Copy to the Jenkins dir
sudo cp keystore.jkd /var/lib/jenkins/

Modify the Jenkins startup script in /etc/default/jenkins with the listing in Appendix A
The Jenkins page can now be seen via browser, https://127.0.0.1:50443.  The url is
https://sauron.us009.siemens.net:50443


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






root@AgentSmith:/var/lib/jenkins# keytool -list -v -keystore keystore.jks -storepass changeme

Keystore type: JKS
Keystore provider: SUN

Your keystore contains 1 entry

Alias name: selfsigned
Creation date: Jan 23, 2013
Entry type: PrivateKeyEntry
Certificate chain length: 1
Certificate[1]:
Owner: CN=agentsmith.us009.siemens.net:50443, OU=Lost, O=sa, L=Florham Park, ST=NJ, C=US
Issuer: CN=agentsmith.us009.siemens.net:50443, OU=Lost, O=Pmi Patchwork, L=Florham Park, ST=NJ, C=US
Serial number: 51001e3f
Valid from: Wed Jan 23 12:30:39 EST 2013 until: Thu Jan 23 12:30:39 EST 2014
Certificate fingerprints:
         MD5:  DA:15:D6:2F:00:81:40:BB:B1:F3:8E:FD:17:46:7D:A8
         SHA1: 01:08:80:6A:FA:CC:E9:2D:FB:A5:19:B8:81:05:60:DB:3B:7F:DF:74
         Signature algorithm name: SHA1withRSA
         Version: 3


*******************************************
*******************************************


LimlawR@Sauron:~$ keytool -genkey -keyalg RSA -alias selfsigned -keystore keystore.jks -storepass changeme -validity 365 -keysize 2048
What is your first and last name?
  [Unknown]:  sauron.us009.siemens.net:50443
What is the name of your organizational unit?
  [Unknown]:  FS20_Voice
What is the name of your organization?
  [Unknown]:  Development
What is the name of your City or Locality?
  [Unknown]:  Florham Park
What is the name of your State or Province?
  [Unknown]:  NJ
What is the two-letter country code for this unit?
  [Unknown]:  US
Is CN=sauron.us009.siemens.net:50443, OU=FS20_Voice, O=Development, L=Florham Park, ST=NJ, C=US correct?
  [no]:  yes

Enter key password for <selfsigned>
        (RETURN if same as keystore password):
Re-enter new password:



