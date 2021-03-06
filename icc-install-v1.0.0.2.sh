#!/bin/bash

echo -e "\n\nupdate & prepare system ...\n\n"
sudo apt-get update -y &&
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y &&
sudo DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y 

sudo apt-get install nano htop git -y


sudo apt-get install unzip -y
sudo apt-get install build-essential libtool autotools-dev automake pkg-config -y
sudo apt-get install libssl-dev libevent-dev bsdmainutils -y
sudo apt-get install libminiupnpc-dev -y
sudo apt-get install libzmq5-dev -y
sudo apt-get install libboost-all-dev -y

sudo add-apt-repository ppa:bitcoin/bitcoin -y
sudo apt-get update -y
sudo apt-get install libdb4.8-dev libdb4.8++-dev -y

echo -e "\n\nsetup iccd ...\n\n"

cd ~

version=`lsb_release -r | awk '{print $2}'`
echo "ubuntu version : "\n
echo $version

mkdir /root/icc
mkdir /root/.icc
mkdir /.icc


cd /root/icc

wget https://github.com/InternetCafeCoin/ICC-CORE/releases/download/v1.0.0.2/icc-cli
sleep 5
wget https://github.com/InternetCafeCoin/ICC-CORE/releases/download/v1.0.0.2/iccd
sleep 5
chmod -R 755 ./*

sleep 5

chmod -R 755 /root/icc
chmod -R 755 /root/.icc

echo -e "\n\nlaunch iccd ...\n\n"
sudo apt-get install -y pwgen
GEN_PASS=`pwgen -1 20 -n`
IP_ADD=`curl ipinfo.io/ip`

echo -e "rpcuser=iccuser\nrpcpassword=${GEN_PASS}\nserver=1\nlisten=1\nmaxconnections=256\ndaemon=1\nrpcallowip=127.0.0.1\nexternalip=${IP_ADD}:50578\nstaking=1" > /root/.icc/icc.conf

ln -s /root/.icc/icc.conf /.icc/icc.conf

cd /root/icc
./iccd
sleep 40
masternodekey=$(./icc-cli masternode genkey)
./icc-cli stop

# add launch after reboot
crontab -l > tempcron
echo "@reboot /root/icc/iccd -reindex >/dev/null 2>&1" >> tempcron
crontab tempcron
rm tempcron

echo -e "masternode=1\nmasternodeprivkey=$masternodekey\n\n\n" >> /root/.icc/icc.conf


sleep 10

sudo ./iccd -reindex
cd /root/.icc
ufw allow 50578

#l3levelerror check
sleep 20
errorcheck=`/root/icc/icc-cli getinfo|grep "\"errors\" : \"\""`
while [ "$errorcheck" != "    \"errors\" : \"\"" ]; do
        sudo /root/icc/icc-cli stop
        sleep 5
        sudo /root/icc/iccd
        sleep 20
        errorcheck=`/root/icc/icc-cli getinfo|grep "\"errors\" : \"\""`
done
rm -rf /.icc

# output masternode key
echo -e "${IP_ADD}:50578"
echo -e "Masternode private key: $masternodekey"
echo -e "Welcome to the ICC Masternode Network!"
