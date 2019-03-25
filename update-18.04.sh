#!/bin/bash

echo -e "\n\nupdate iccd ...\n\n"
cd /root/icc
./icc-cli stop
sleep 10

rm /root/icc/iccd
rm /root/icc/icc-cli

wget https://github.com/InternetCafeCoin/ICC-CORE/releases/download/v1.0/icc-linux-v1.0.zip
chmod -R 755 /root/icc/icc-linux-v1.0.zip
unzip -o /root/icc/icc-linux-v1.0.zip
sleep 5

rm /root/icc/icc-linux-v1.0.zip

chmod -R 755 /root/icc/*

echo -e "\n\nlaunch iccd ...\n\n"
./iccd -reindex

echo "ICC Masternode updated"
