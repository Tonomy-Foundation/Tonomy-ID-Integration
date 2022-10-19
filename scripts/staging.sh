#!/bin/bash

# Extra pre-requisits to install

sudo apt install -y nginx
cp ../nginx/nginx.conf /etc/nginx/conf.d/default.conf

# Commands for the staging server

git clone https://github.com/Tonomy-Foundation/Tonomy-ID-Integration.git
cd Tonomy-ID-Integration
git checkout development
./apps.sh gitinit
./apps.sh install
./apps.sh init
./apps.sh start

# next time, to upgrade
cd Tonomy-ID-Integration
./apps.sh stop
git pull
cd Tonomy-ID
git pull
cd ../Tonomy-Contracts
git pull
cd ../Tonomy-ID-SDK
git pull
cd ../Tonomy-ID-Demo
git pull
cd ../
./apps.sh init
./apps.sh start