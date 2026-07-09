
ClearCase full client install on 32-bit (x86)

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
rcleartool set -pref CLEARCASE_PRIMARY_GROUP -val "ww009\USFHP-CC_EngDefault-U"
rcleartool set -pref CLEARCASE_PRIMARY_GROUP -val "AD001\RA010-U-FHP-CCENGDEFAULT"
rcleartool set -pref CLEARCASE_GROUP_LIST -val "ww009\USFHP-CC_EngDefault-U;ww009\USFHP-CC_EngDefault-U;ww009\USFHP-CC_FS20-U;ww009\USFHP-CC_MNS-U;ww009\USFHP-CC_HW-U;ww009\USFHP-CC_XLS-U;ww009\USFHP-CC_XLS_PNB-U;ww002\SBT-CCCCP-MEM"
rcleartool set -pref CLEARCASE_GROUP_LIST -val "AD001\RA010-U-FHP-CCENGDEFAULT;AD001\RA010-U-FHP-CCFS20;AD001\RA010-U-FHP-CCHW;AD001\RA010-U-FHP-CCMNS;AD001\RA010-U-FHP-CCXLS;AD001\RA010-U-FHP-CCXLS-PNB;AD001\RA010-U-ZUG-CCCCP"
rcleartool set -pref SERVER_URL -val https://usfhp00001esrv.ww009.siemens.net/ccrc
rcleartool set -pref SERVER_URL -val https://usfhp00001msrv.ad001.siemens.net/ccrc
rcleartool set -pref NON_LATEST_CHECKOUT -val LATEST

AD001\RA010-U-FHP-CCENGDEFAULT;AD001\RA010-U-FHP-CCFS20;AD001\RA010-U-FHP-CCHW;AD001\RA010-U-FHP-CCMNS;AD001\RA010-U-FHP-CCXLS;AD001\RA010-U-FHP-CCXLS-PNB;AD001\RA010-U-ZUG-CCCCP

