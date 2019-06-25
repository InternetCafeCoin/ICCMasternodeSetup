
#!/bin/bash

echo -e "\n\nupdate iccd ...\n\n"
cd /root/icc
./icc-cli stop
sleep 10

rm /root/icc/iccd
rm /root/icc/icc-cli

sleep 1 

version=`lsb_release -r | awk '{print $2}'`
echo "ubuntu version : "\n
echo $version


echo "setup icc for ubuntu $version\n"
wget https://github.com/InternetCafeCoin/ICC-CORE/releases/download/v1.0.0.2/icc-cli
wget https://github.com/InternetCafeCoin/ICC-CORE/releases/download/v1.0.0.2/iccd

sleep 5

chmod -R 755 /root/icc/*

echo -e "\n\nlaunch iccd ...\n\n"
./iccd -reindex

echo "ICC Masternode Updated"
