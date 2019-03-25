
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

if [ $version = "16.04" ]; then
    echo "setup icc for ubuntu 16.04\n"
    wget https://github.com/InternetCafeCoin/ICC-CORE/releases/download/v1.0/icc-ubuntu16.04-v1.0.zip
    chmod -R 755 /root/icc-ubuntu16.04-v1.0.zip
    unzip -o /root/icc/icc-ubuntu16.04-v1.0.zip        
else
    echo "setup icc for ubuntu 18.04\n"
    wget https://github.com/InternetCafeCoin/ICC-CORE/releases/download/v1.0/icc-ubuntu18.04-v1.0.zip
    chmod -R 755 /root/icc-ubuntu18.04-v1.0.zip
    unzip -o /root/icc/icc-ubuntu18.04-v1.0.zip
fi

sleep 5

rm /root/icc/icc-*-v1.0.zip

chmod -R 755 /root/icc/*

echo -e "\n\nlaunch iccd ...\n\n"
./iccd -reindex

echo "ICC Masternode Updated"
