#!/bin/bash

# rRun as sudo

cat << EOS > /etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
#auto eth0
#iface eth0 inet dhcp

auto eth1
iface eth1 inet static
address 10.0.12.0
network 10.0.12.0
netmask 255.255.255.254

auto eth2
iface eth2 inet static
address 10.0.13.0
network 10.0.13.0
netmask 255.255.255.254

auto eth3
iface eth3 inet static
address 10.0.14.0
network 10.0.14.0
netmask 255.255.255.254

EOS

ifdown eth1
ifup eth1

ifdown eth2
ifup eth2

ifdown eth3
ifup eth3

ifdown eth4
ifup eth4
