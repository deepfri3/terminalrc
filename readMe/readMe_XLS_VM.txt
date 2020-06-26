Install/update Debian Wheezy for the VM:

Started with dev.one.sbt.siemens.com_V03.06 VM (we are using 32 bit).

cntlm for the ISA proxy service:
Download cntlm_0.92.3_i386.deb
sudo dpkg -i cntlm_0.92.3_i386.deb

you will need to modify the cntlm.conf as root. Copy example in Appendix A and update with needed info.

Execute the following.
sudo invoke-rc.d cntlm stop
sudo cntlm -I -M http://google.com
Enter password.

Copy PassNTLMv2 value into cntlm.conf.
Execute the following.
sudo service cntlm start

Proxy setup for machine:

in /etc/profile, append to file.
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

in subversion config:
edit ~/.subversion/servers
In the [global] section, add
http-proxy-host = 127.0.0.1
http-proxy-port = 3128

Add the wandisco key for subversion:
wget http://opensource.wandisco.com/wandisco-debian.gpg -O ~/wd-deb.gpg
sudo apt-key add ~/wd-deb.gpg
sudo rm ~/wd-deb.gpg


To upgrade system:
replace the /etc/apt/source.list with the following
#
# squeeze-updates, previously known as 'volatile'
# A network mirror was not selected during install.  The following entries
# are provided as examples, but you should amend them as appropriate
# for your mirror of choice.
#
deb http://ftp.us.debian.org/debian/ wheezy main contrib non-free
deb-src http://ftp.us.debian.org/debian/ wheezy main contrib non-free

deb http://security.debian.org/ wheezy/updates main contrib non-free
deb-src http://security.debian.org/ wheezy/updates main contrib non-free

deb http://ftp.us.debian.org/debian/ wheezy-updates main contrib non-free
deb-src http://ftp.us.debian.org/debian/ wheezy-updates main contrib non-free

#deb http://ftp.us.debian.org/debian/ wheezy-backports main contrib non-free
#deb-src http://ftp.us.debian.org/debian/ wheezy-backports main contrib non-free

#deb http://opensource.wandisco.com/debian/ wheezy svn18

Then run:
sudo apt-get update
sudo atp-get upgrade
sudo apt-get dist-upgrade


The /etc/sudoers file needs to be modified:
sudo chmod 0640 /etc/sudoers

edit /etc/sudoers file with the following, and add 'Defaults  secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"', after the line 'Defaults  env_reset'.
sudo chmod 0440 /etc/sudoers


Adding public keys for repositories:
Execute:
sudo apt-get update
An error(s) occur for the public key (NO_PUBKEY), copy a key into the following command (repeat for all missing keys). I used the following key server, wwwkeys.cz.pgp.net.

gpg --keyserver keyServer --recv-keys Xx_key_xX
gpg --export --armor Xx_key_xX | sudo apt-key add -

Example:
gpg --keyserver wwwkeys.cz.pgp.net --recv-keys 9BDB3D89CE49EC21
gpg --export --armor 9BDB3D89CE49EC21 | sudo apt-key add -


Update the kernel:
sudo apt-get install linux-image-686
reboot
sudo apt-get install linux-headers-$(uname -r)


VMWare (8.0.4) tools for Linux (3.2):
copy tools to path/
cp path/vmware-tools-distrib/lib/modules/source/vmhgfs.tar ~/
cd ~/
tar xf vmhgfs.tar 
cd vmhgfs-only/
sed -i 's/d_alias/d_u.d_alias/g' inode.c
rm vmhgfs.tar
tar cvf vmhgfs.tar vmhgfs-only
cp vmhgfs.tar path/vmware-tools-distrib/lib/modules/source/
sudo path/vmware-install.pl

The fast ethernet modules fails to build.  This is ok.

Reconfigure the keyboard for command line:
sudo apt-get install console-data
sudo dpkg-reconfigure console-data
sudo dpkg-reconfigure keyboard-configuration


Setting up eclipse:
sudo apt-get install openjdk-7-jre
sudo apt-get install eclipse-cdt eclipse-gef

Update eclipse:

Install all update and packages as root.

Menu "Help" -> "Check for Updates"

Copy CCRC-Eclipse to the /home/one dir.
\\bt-clmserver01.hqs.sbt.siemens.com\CM_REPOSITORY\CCQ_Client\CCRC-Eclipse

Install the ClearTeam package:
Add the repository under Help -> Install New Software.
Add the repository /home/one/CCRC-Eclipse
Select "IBM Rational ClearTeam Explorer", and install.

rcleartool:
cd /usr/lib/eclipse
sudo cp plugins/com.ibm.rational.ccrc.cli_8.0.0.v20140829_0334/scripts/rcleartool rcleartool
sudo cp rcleartool rcleartool.orig
edit _JAVACMD to _JAVACMD=${_JAVACMD:-/usr/bin/java}
sudo chmod 0755 rcleartool

Run rcleartool as root the first time.
sudo ./rcleartool

cd /usr/local/bin
sudo ln -s /usr/lib/eclipse/rcleartool /usr/local/bin/rcleartool


Install the CDT packages:

Install all update and packages as root.

Add the repository under Help -> Install New Software.
http://download.eclipse.org/tools/cdt/releases/indigo
Select "C/C++ Development Tools", "DSF GDB Debugger Integration", "C/C++ GNU Toolchain Support", "C/C++ GCC Cross Compilers Support" and install.
mkdir prettyPrint
cd prettyPrint
svn co https://gcc.gnu.org/svn/gcc/trunk/libstdc++-v3/python
cd
edit .gdbinit, and add:
python
import sys
sys.path.insert(0, '/home/one/prettyPrint/python')
sys.path.insert(0, '/home/one/prettyPrint/python/libstdcxx/v6')
from libstdcxx.v6.printers import register_libstdcxx_printers
end

create an app and compile and debug at least run debugger once.
Menu "RUN" -> "Debug Configurations".
In dialog double click "C/C++ Application".
On the "Debugger" tab,  set "GDB command file:" to /home/one/.gdbinit
run baby run.

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
Proxy     proxyfarm-na.inac.siemens.net:84  # modify if proxy changes
#Proxy		10.0.0.41:8080
#Proxy		10.0.0.42:8080

# List addresses you do not want to pass to parent proxies
# * and ? wildcards can be used
#
#NoProxy		localhost, 127.0.0.*, 10.*, 192.168.*
NoProxy     localhost, 127.0.0.*, 136.157.32.*, 136.157.33.*, 136.157.34.*, 136.157.43.*

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
#Allow		127.0.0.1
#Deny		0/0

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
