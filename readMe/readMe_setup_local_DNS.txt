 https://www.digitalocean.com/community/tutorials/how-to-configure-bind-as-a-private-network-dns-server-on-ubuntu-14-04


How to setup a Debian/Ubuntu host to use Kane as a DNS server

Add the following to '/etc/resolv.conf':
domain us009.fhpprivate.net
search us009.fhpprivate.net
nameserver 136.157.0.156 # 1 Kane - private DNS
nameserver 136.157.0.2   # 2 usfhp00eng0010 - gateway/DHCP

This will make it so the Linux machine will ask Kane first, the DHCP second for name resolution

Test it using the nslookup command to resolve "AgentSmith", successful command should looke like this:
$ nslookup AgentSmith
Server:         136.157.0.156
Address:        136.157.0.156#53

Name:   AgentSmith.us009.fhpprivate.net
Address: 136.157.0.154

$

Server -> the DNS Server
Address -> the IP Address and port of the DNS server (Port 53 is the standard DNS port)
Name -> the full hostname of the request lookup (name + private domain)
Address: the IP Address of the requested hostname

A failed commmand should look something like this:
$ nslookup machine
;; Got SERVFAIL reply from 136.157.0.2, trying next server
Server:         136.157.0.156
Address:        136.157.0.156#53

** server can't find machine: SERVFAIL

returned 1
$


Note: The private DNS works on static addresses. It does not dynamically resolve hostnames. This means that as hosts are added/removed from the domain, the private DNS is not updated.
        136.157.0.156;  # ns1 - Kane
        136.157.0.2;    # ns2 - usfhp00eng0010
        136.157.0.1;    # ns3 - extrouter
        136.157.0.157;  # host2 - usfhpnas4
        136.157.0.158;  # host3 - usfhpnas5
        136.157.0.153;  # host4 - usfhpnas3
        136.157.0.154;  # host5 - AgentSmith
        136.157.0.159;  # host6 - Sauron
        136.157.0.100;  # host7 - sbtusfhp2736ws

See: "How to setup a static IP on your Linux machine"





