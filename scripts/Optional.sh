#!/usr/bin/env bash


# Run as sudo

# Waiting up to 60more seconds for network configuration 無効
sed -i -e "s:/etc/udev/rules.d/70-persistent-net.rules:/dev/null:" /lib/udev/write_net_rules
echo "" > /etc/udev/rules.d/70-persistent-net.rules
echo "" > /lib/udev/rules.d/75-persistent-net-generator.rules

sed -i -e "s/sleep 40/sleep 10/" /etc/init/failsafe.conf
sed -i -e "s/sleep 59/sleep 1/" /etc/init/failsafe.conf

# IPv6 無効
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf

sysctl -p