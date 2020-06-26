https://technet.microsoft.com/en-us/library/cc756722(v=ws.10).aspx

How Dynamic and Static Mappings and IP Reservations Work

In addition to the dynamic mapping just introduced in “How Address and Port Translation Work,” Routing and Remote Access NAT technology provides for two additional types of entries in the NAT Mapping Table: static mapping and IP reservations. Each of the three mapping types is designed for a different purpose.
Dynamic Mapping

Whenever a NAT-enabled router receives an outgoing TCP or UDP packet from a local client that is initiating communications with a computer on the public network, the NAT driver creates an entry in the NAT Mapping Table, called a 5-tuple entry, that contains the following five pieces of information:

{protocol (TCP or UDP), private address, private port, public address, public port}

An alternative notation representing this 5-tuple entry is the following:

{protocol (TCP or UPD), source address, source port, destination address, destination port}

The private address and port pair are automatically (dynamically) mapped to the public address and port pair. This is the type of mapping illustrated earlier in “How Address and Port Translation Work.” This entry in the NAT Mapping Table enables the NAT-enabled router to direct a response packet from a computer on the public network back to the client on the private network that sent initial the request.

Because the number of mappings that can be established is limited by the number of available 16-bit TCP and UDP ports, the NAT driver must eventually delete the dynamic mappings that it creates in order to free up port numbers for use in new mappings. A dynamic mapping entry remains in the mapping table for the length of time that the administrator specifies on the Translation tab for the properties of the NAT/Basic Firewall component in the Routing and Remote Access snap-in. Routing and Remote Access NAT, by default, uses the RFC 1631 recommended timeouts of 24 hours for idle TCP mappings and 1 minute for idle UDP mappings.
Static Mapping

With dynamic mapping, in order for a TCP or UDP packet to pass through the NAT from the public network to the private network, a mapping must have been established previously by a packet sent from the private to the public network. However, if a client on the public network attempts to establish a TCP or UDP session with a computer on the private network (such as a Web server on the private network or a computer on the private network that provides a game application), no dynamic mapping will be found and the incoming packet will be discarded.

If an organization wants to allow such incoming traffic to a specific computer on the private network, Routing and Remote Access NAT allows an administrator to use the Services and Ports tab on the properties page of the public interface in the Routing and Remote Access snap-in to configure a static mapping for this traffic. Thus, the way that the NAT-enabled router forwards Internet traffic into its private network is either in response to traffic initiated by a user on the private network, which creates a dynamic mapping, or because an administrator has configured a static mapping to enable Internet users to access specific resources on the private network. (For an alternative to static mapping, see “IP Reservations” later in this section).

Static mappings have limited usefulness for connections between a private network and the Internet because of the large number of possible connections. Too many connections can make the NAT Mapping Table grow excessively and thus slow router performance.

A static mapping consists of a 5-tuple entry identical in content to a dynamic mapping entry:

{protocol (TCP or UDP), private address, private port, public address, public port}

Unlike a dynamic mapping, a static mapping explicitly matches a given TCP or UDP port number to both the private and the public address in the static entry in the mapping table. For example, to set up a Web server on a computer on a private network, an administrator could create a static mapping that maps [Public IPv4 Address, TCP Port 80] to [Private IPv4 Address, TCP Port 80]. Port 80 is, by convention, assigned to the World Wide Web (WWW) and used by Web servers for HTTP traffic. When a packet arrives for Public IPv4 Address and Port 80, the NAT-enabled router directs the packet to the Web server on the private network.

Any server running on a well-known port on the private network (such as HTTP or FTP servers) can have only one instance accessible to clients running on the public network.

Multiple interfaces can have translation enabled at the same time, as in the case of a home where a user connects both to the Internet and to a corporate network. Therefore, static mappings in Routing and Remote Access NAT can be configured on a per-interface basis.

A static mapping entry remains in the mapping table until an administrator deletes it.
