
$ sudo apt-get install squid3

The default configuration file for squid is located under ‘/etc/squid3/squid.conf‘ or ‘/etc/squid/squid.conf‘. This file contains some configuration directives that needs to be configured to affect the behavior of the Squid.

Now open this file for editing using Vi editor and make changes as shown below.

$ sudo vi /etc/squid3/squid.conf

Here is the complete listing of squid.conf for your reference (grep will remove all comments and sed will remove all empty lines, thanks to David Klein for quick hint ):
# grep -v "^#" /etc/squid/squid.conf | sed -e '/^$/d'

OR, try out sed (thanks to kotnik for small sed trick)
# cat /etc/squid/squid.conf | sed '/ *#/d; /^ *$/d'

Configure Squid Proxy To Forward To A Parent Proxy
https://www.rootusers.com/configure-squid-proxy-to-forward-to-a-parent-proxy/

Can I make Squid go direct for some sites?
Sure, just use the always_direct access list.
For example, if you want Squid to connect directly to hotmail.com servers, you can use these lines in your config file:
acl hotmail dstdomain .hotmail.com
always_direct allow hotmail

Example configuration (For Kane on RD.net):
acl SSL_ports port 443    # standard SSL port
acl SSL_ports port 8443   # confluence SSL port
acl Safe_ports port 80		# http
acl Safe_ports port 21		# ftp
acl Safe_ports port 443		# https
acl Safe_ports port 70		# gopher
acl Safe_ports port 210		# wais
acl Safe_ports port 1025-65535	# unregistered ports
acl Safe_ports port 280		# http-mgmt
acl Safe_ports port 488		# gss-http
acl Safe_ports port 591		# filemaker
acl Safe_ports port 777		# multiling http
acl Safe_ports port 8443  # confluence
acl CONNECT method CONNECT
acl PURGE method PURGE
acl rdnet_ips src 136.157.0.0/24
acl corp_ips src 136.157.32.0/24 136.157.34.0/24
acl nasbox_ips src 136.157.0.157/32 136.157.0.158/32
acl rdnet_domain dstdomain .us009.fhpprivate.net
acl corp_domain dstdomain .us009.siemens.net
http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
http_access allow localhost manager
http_access deny manager
http_access deny to_localhost
http_access allow localhost
http_access allow rdnet_ips
http_access deny all
icp_access allow rdnet_ips
icp_access deny all
http_port 3128
cache_peer proxyfarm-na.inac.siemens.net parent 84 0 no-query no-digest default --connection-auth=off --login=PASS
always_direct deny rdnet_ips
always_direct deny localhost
never_direct deny rdnet_domain
never_direct allow all
cache_mem 8192 MB
maximum_object_size 256 MB
cache_dir aufs /var/spool/squid3 81920 16 256
coredump_dir /var/spool/squid3
refresh_pattern ^ftp:		1440	20%	10080
refresh_pattern ^gopher:	1440	0%	1440
refresh_pattern -i \.(gif|png|jpg|jpeg|ico)(\?.*)?$  3600 90% 43200
refresh_pattern -i (/cgi-bin/|\?) 0	0%	0
refresh_pattern -i \.index.(html|html)(\?.*)?$ 0 40% 10080
refresh_pattern -i \.(html|htm|css|js|json)(\?.*)?$ 1440 40% 40320 
refresh_pattern .		0	20%	4320
nonhierarchical_direct off
prefer_direct on
