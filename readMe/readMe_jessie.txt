

Upgrading from Wheezy

https://www.debian.org/releases/stable/i386/release-notes/ch-upgrading
https://www.debian.org/releases/stable/i386/release-notes/ch-upgrading.en.html#updating-lists

Install Debian Jessie

Created Date: 2014/01/06
Author: Robert Limlaw (robert.limlaw@siemens.com)
Last Modified: 2014/02/20 by George Baker (george.baker@siemens.com)


Configure repositories for apt:
edit /etc/apt/sources.list
#############################################################################
# Debian jessie sources
############################################################################
deb http://ftp.us.debian.org/debian/ jessie main contrib non-free
deb-src http://ftp.us.debian.org/debian/ jessie main contrib non-free

deb http://ftp.us.debian.org/debian/ jessie-backports main contrib non-free
deb-src http://ftp.us.debian.org/debian/ jessie-backports main contrib non-free

deb http://security.debian.org/ jessie/updates main contrib non-free
deb-src http://security.debian.org/ jessie/updates main contrib non-free

# wheezy-updates, previously known as 'volatile'
deb http://ftp.us.debian.org/debian/ jessie-updates main contrib non-free
deb-src http://ftp.us.debian.org/debian/ jessie-updates main contrib non-free

##Code::Blocks
deb http://apt.jenslody.de/stable jessie main
deb-src http://apt.jenslody.de/stable jessie main

# firefox
#deb http://packages.linuxmint.com debian import

#LLVM/Clang - Jessie (Debian stable)
#deb http://llvm.org/apt/jessie/ llvm-toolchain-jessie main
#deb-src http://llvm.org/apt/jessie/ llvm-toolchain-jessie main
# 3.6 
deb http://llvm.org/apt/jessie/ llvm-toolchain-jessie-3.6 main
deb-src http://llvm.org/apt/jessie/ llvm-toolchain-jessie-3.6 main

Run:
sudo apt-get update

Make sure you have sufficient space for the upgrade:

Run:
sudo apt-get -o APT::Get::Trivial-Only=true dist-upgrade

E: You don't have enough free space in /var/cache/apt/archives/.
Try:
sudo apt-get clean
sudo apt-get autoremove

Use temporary location for the upgrade:
Use a temporary /var/cache/apt/archives: 
You can use a temporary cache directory from another filesystem:
-USB storage device, temporary hard disk, filesystem already in use

Use share drive on host computer: /mnt/hgfs/share/archives

sudo apt-get clean

copy the directory /var/cache/apt/archives to the USB drive:
cp -ax /var/cache/apt/archives /mnt/hgfs/share/archives

mount the temporary cache directory on the current one:
mount --bind /mnt/hgfs/share/archives /var/cache/apt/archives

after the upgrade, restore the original /var/cache/apt/archives directory:
umount /mnt/hgfs/share/archives
remove the remaining /mnt/hgfs/share/archives

Note: you may have to reinstall the kdm after upgrading to Jessie
sudo apt-get install kdm kde-baseapps


Packages for bitbake:
You can install them seperately.
sudo apt-get update
sudo apt-get install sed wget cvs subversion git-core coreutils unzip texi2html texinfo docbook-utils \
gawk python-pysqlite2 diffstat help2man make gcc build-essential g++ chrpath libtool \
desktop-file-utils libncurses5 curl bison bc python python-ply python-progressbar patch \
m4 perl libpcre3-dev libc6-dev libsdl1.2-dev qemu libxml2-utils xmlto quilt cifs-utils


ClearCase full client install:

Packages that need to be installed ClearCase:
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install libgtk2.0-0:i386
sudo apt-get install lib32ncurses5
sudo apt-get install lib32z1
sudo apt-get install libboost-dev:i386
sudo apt-get install libmotif4:i386
sudo apt-get install libXtst-dev:i386
sudo apt-get install libXp6:i386
-Dorg.eclipse.swt.internal.gtk.disablePrinting in install.ini and IBMIM.ini

The ibm installer works with firefox and not iceweasel, so install firefox.
sudo apt-get install firefox

Install  IBM Installation Manager:
export BROWSER=/usr/bin/firefox
Copy the installation manager sources onto the machine
* You can download the latest installation manager from IBM Support
** As of this writing the latest version is 1.8.4.1

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

Set group list for rcleartool:
rcleartool set -pref CLEARCASE_GROUP_LIST -val "ww009\USFHP-CC_EngDefault-U;ww009\USFHP-CC_EngDefault-U;ww009\USFHP-CC_FS20-U;ww009\USFHP-CC_MNS-U;ww009\USFHP-CC_HW-U;ww009\USFHP-CC_XLS-U;ww009\USFHP-CC_XLS_PNB-U;ww002\SBT-CCCCP-MEM"

https://www.debian-administration.org/article/50/Running_applications_automatically_when_X_starts

