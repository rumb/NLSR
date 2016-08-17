#!/bin/bash

# rRun as sudo

cat << EOS > /etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto eth0
#iface eth0 inet dhcp
iface eth0 inet static
address 10.0.14.1
netmask 255.255.255.254

EOS

ifdown eth0
ifup eth0
