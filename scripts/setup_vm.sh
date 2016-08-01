#virtualbox用設定
#for Ubuntu 14.04

sudo apt-get update
sudo apt-get install -y virtualbox-guest-additions-iso
sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get install -y virtualbox-guest-x11

# GNS3 console

cat << EOS > ttyS0.conf
# ttyS0 - getty
#
# This service maintains a getty on ttyS0 from the point the system is
# started until it is shut down again.

start on stopped rc RUNLEVEL=[12345]
stop on runlevel [!12345]

respawn
exec /sbin/getty -L 115200 ttyS0 vt102
EOS
sudo cp ttyS0.conf /etc/init/ttyS0.conf
sudo start ttyS0
