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
# sudo apt-get install libzmq3-dev -y

echo -e "\n\nsetup iccd ...\n\n"

cd ~

version=`lsb_release -r | awk '{print $2}
echo "ubuntu version : "\n
echo $version

if [ $version = "16.04" ]; then
    echo "setup icc for ubuntu 16.04\n"
    wget https://github.com/InternetCafeCoin/ICC-CORE/releases/download/v1.0/icc-ubuntu16.04-v1.0.zip
    chmod -R 755 /root/icc-ubuntu16.04-v1.0.zip
    unzip -o icc-ubuntu16.04-v1.0.zip        
else
        echo "setup icc for ubuntu 18.04\n"
    wget https://github.com/InternetCafeCoin/ICC-CORE/releases/download/v1.0/icc-ubuntu18.04-v1.0.zip
    chmod -R 755 /root/icc-ubuntu18.04-v1.0.zip
    unzip -o icc-ubuntu18.04-v1.0.zip
fi



sleep 5

mkdir /root/icc
mkdir /root/.icc
cp /root/iccd /root/icc
cp /root/icc-cli /root/icc

sleep 5

rm /root/iccd
rm /root/icc-cli
rm icc-*-v1.0.zip


chmod -R 755 /root/icc
chmod -R 755 /root/.icc

echo -e "\n\nlaunch iccd ...\n\n"
sudo apt-get install -y pwgen
GEN_PASS=`pwgen -1 20 -n`
IP_ADD=`curl ipinfo.io/ip`

echo -e "rpcuser=iccuser\nrpcpassword=${GEN_PASS}\nserver=1\nlisten=1\nmaxconnections=64\ndaemon=1\nrpcallowip=127.0.0.1\nexternalip=${IP_ADD}:50578\nstaking=1" > /root/.icc/icc.conf
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


echo -e "addnode=54.180.86.25" >> /root/.icc/icc.conf
echo -e "addnode=54.180.79.209" >> /root/.icc/icc.conf
echo -e "addnode=52.78.223.170" >> /root/.icc/icc.conf
echo -e "addnode=52.79.188.55" >> /root/.icc/icc.conf
echo -e "addnode=13.125.249.55" >> /root/.icc/icc.conf
echo -e "addnode=54.180.107.85" >> /root/.icc/icc.conf
echo -e "addnode=13.125.241.77" >> /root/.icc/icc.conf
echo -e "addnode=54.180.88.115" >> /root/.icc/icc.conf
echo -e "addnode=54.180.92.125" >> /root/.icc/icc.conf
echo -e "addnode=52.78.29.42" >> /root/.icc/icc.conf

sleep 10

./iccd -reindex
cd /root/.icc
ufw allow 50578

# output masternode key
echo -e "${IP_ADD}:50578"
echo -e "Masternode private key: $masternodekey"
echo -e "Welcome to the ICC Masternode Network!"
