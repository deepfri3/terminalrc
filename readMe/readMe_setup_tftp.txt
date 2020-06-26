
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
server_args = /home/one/tftpboot #(use your tftpboot directory location)
disable = no
}

4. Add this to /etc/inetd.conf

# /etc/inetd.conf:  see inetd(8) for further informations.
#
# Internet superserver configuration database
#
#
# Lines starting with "#:LABEL:" or "#<off>#" should not
# be changed unless you know what you are doing!
#
# If you want to disable an entry so it isn't touched during
# package updates just comment it out with a single '#' character.
#
# Packages should modify this file by using update-inetd(8)
#
# <service_name> <sock_type> <proto> <flags> <user> <server_path> <args>
#
#:INTERNAL: Internal services
#discard                stream  tcp     nowait  root    internal
#discard                dgram   udp     wait    root    internal
#daytime                stream  tcp     nowait  root    internal
#time           stream  tcp     nowait  root    internal

#:STANDARD: These are standard services.

#:BSD: Shell, login, exec and talk are BSD protocols.

#:MAIL: Mail, news and uucp services.

#:INFO: Info services

#:BOOT: TFTP service is provided primarily for booting.  Most sites
#       run this only on machines acting as "boot servers."
tftp            dgram   udp     wait    nobody  /usr/sbin/tcpd  /usr/sbin/in.tftpd -s /home/one/tftpboot

#:RPC: RPC based services

#:HAM-RADIO: amateur-radio services

#:OTHER: Other services
#<off># sane-port       stream  tcp     nowait  saned:saned     /usr/sbin/saned saned

'4. Restart the xinetd service.'
sudo /etc/init.d/xinetd restart

Now our tftp server is up and running.
