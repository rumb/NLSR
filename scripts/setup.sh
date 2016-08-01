#i NLSR導入
# for Ubuntu14.04

# ゴミを消去
sudo apt-get remove -y libreoffice*
sudo apt-get remove -y firefox*
sudo apt-get remove -y thunderbird*

# 必要なものをダウンロード&インストール
sudo apt-add-repository ppa:midori/ppa
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install git ssh vim
sudo apt-get -y install midori

sudo apt-get -y install build-essential libcrypto++-dev libsqlite3-dev libboost-all-dev
sudo apt-get -y install doxygen graphviz python-sphinx python-pip
sudo pip install sphinxcontrib-doxylink sphinxcontrib-googleanalytics
sudo apt-get -y install pkg-config
sudo apt-get -y install libpcap-dev
sudo apt-get -y install liblog4cxx10-dev
sudo apt-get -y install libprotobuf-dev protobuf-compiler
sudo apt-get -y install libssl-dev
# Wireshark
sudo apt-get -y --force-yes install bison flex libgtk-3-dev  libqt4-dev  libpcap-dev
sudo apt-get -y install liblua5.2-dev
# NDN Packet Dissector for Wireshark
sudo apt-get -y install libcap2-bin

mkdir ~/ndn
cd ~/ndn/

git clone https://github.com/named-data/ndn-cxx
git clone --recursive https://github.com/named-data/NFD
git clone https://github.com/named-data/ChronoSync.git
git clone https://github.com/named-data/NLSR.git
git clone https://github.com/named-data/ndn-tools.git
wget https://1.as.dl.wireshark.org/src/wireshark-1.12.12.tar.bz2

# ndn-cxx
cd ~/ndn/ndn-cxx/
git checkout ndn-cxx-0.4.0
./waf configure --enable-static  --with-examples
./waf
sudo ./waf install
sudo ldconfig

# NFD
cd ~/ndn/NFD/
git checkout NFD-0.4.0
./waf configure
./waf
sudo ./waf install
sudo cp /usr/local/etc/ndn/nfd.conf.sample /usr/local/etc/ndn/nfd.conf

# ChronoSync
cd ~/ndn/ChronoSync
git checkout edaef7c4123f6e250a741912b2747b0b7e233b8a
./waf configure
./waf
sudo ./waf install

# NLSR
cd ~/ndn/NLSR/
git checkout NLSR-0.2.2
./waf configure
./waf
sudo ./waf install
sudo mkdir /var/log/nlsr
sudo chmod 777 /var/log/nlsr
sudo mkdir /var/lib/nlsr
sudo chmod 777 /var/lib/nlsr

# Wireshark
cd ~/ndn/
tar jxvf wireshark-1.12.12.tar.bz2
cd wireshark-1.12.12/
./configure --prefix=/usr/local/wireshark --with-lua
make
sudo make install
sudo groupadd wireshark
sudo usermod -a -G wireshark sunaga
sudo chgrp wireshark /usr/local/wireshark/bin/dumpcap
sudo chmod 750 /usr/local/wireshark/bin/dumpcap
sudo setcap cap_net_raw,cap_net_admin=eip /usr/local/wireshark/bin/dumpcap

# nan-tools
cd ~/ndn/ndn-tools/
./waf configure
./waf
sudo ./waf install
sudo bash -c 'echo "dofile(\"/usr/local/share/ndn-dissect-wireshark/ndn.lua\")"  >> /usr/local/wireshark/share/wireshark/init.lua'
