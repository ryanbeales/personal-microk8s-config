#!/bin/sh

# Why? 
# I don't control DHCP on my network. And _sometimes_ it decides that reserved IPs aren't reserved and just changes a whole bunch of ips on my network.
# So this will take an input of MAC:hostnames, scan the network for MAC:IP's, then merge the two to generate a list of hostname:IP that can be fed in to CoreDNS.

# Install YQ - because I'm not publishing my own image and I'm using an existing image that does not have yq, I need to install it (Later on, I can make my own).
apk add yq

# Perform a ping scan, this will contain both MAC and IP addresses for each host on the network
nmap -sP -PR 10.0.0.0/24 -oX output.xml

# Use yq to convert the XML output of nmap, in to a yaml output that can be merged with our config. The output will look like:
# macaddress1:
#   ip: 1.1.1.1
# macaddress2:
#   ip: 2.2.2.2
cat output.xml | yq -p=xml '.nmaprun.host[] | select(.status.+@reason == "arp-response") | { .address[] | select(.+@addrtype == "mac") | .+@addr: {"ip": .address[] | select(.+@addrtype == "ipv4") | .+@addr }}' > /coredns-config/mac-ip.yaml

# Merge the MAC/IP data with the MAC/Hostname configuration we've prepared earlier, this looks like:
# macaddress1:
#   name: host1
# macaddress2:
#   name: host2
yq '. *= load("/config/mac-names.yaml")'  /coredns-config/mac-ip.yaml > /coredns-config/hosts.yaml


# Create the header for the zone file
cat <<EOF > /coredns-config/home.db.tmp
\$TTL    3600
\$ORIGIN home.ryanbeales.com.
@ IN  SOA  ns.home.ryanbeales.com. contact.home.ryanbeales.com. (
                                               $(date +%y%m%d%H%M) ; serial
                                               1h ; refresh
                                               1h ; retry
                                               1h ; expire
                                               1h ; nxdomain ttl
                                              )
EOF

# Use the hosts.yaml to create a database file for CoreDNS
yq 'to_entries | .[] | select(.value.name == "*") | .value.name + " IN A " + .value.ip' /coredns-config/hosts.yaml >> /coredns-config/home.db.tmp

# Move over top of existing file - this prevents coredns only picking up half the file if the above commands are running while coredns is refreshing
mv /coredns-config/home.db.tmp /coredns-config/home.db