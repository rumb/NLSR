#!/bin/bash

# virtualbox用の追加設定
# for Ubuntu 14.04

# Run as sudo

apt-get update
apt-get install -y virtualbox-guest-additions-iso
apt-get update
apt-get dist-upgrade -y
apt-get install -y virtualbox-guest-x11

# GNS3 console
cat << EOS > /etc/init/ttyS0.conf
# ttyS0 - getty
#
# This service maintains a getty on ttyS0 from the point the system is
# started until it is shut down again.

start on stopped rc RUNLEVEL=[12345]
stop on runlevel [!12345]

respawn
exec /sbin/getty -L 115200 ttyS0 vt102

EOS

start ttyS0
