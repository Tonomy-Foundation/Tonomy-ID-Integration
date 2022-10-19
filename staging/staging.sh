#!/bin/bash

# Extra pre-requisits to install

sudo apt install -y nginx
cp ./nginx.conf /etc/nginx/conf.d/default.conf
sudo systemctl restart nginx

# Commands for the staging server

export NODE_ENV=staging
git clone https://github.com/Tonomy-Foundation/Tonomy-ID-Integration.git
cd Tonomy-ID-Integration
git checkout development
./apps.sh gitinit
./apps.sh install
./apps.sh init
./apps.sh start

# next time, to upgrade
export NODE_ENV=staging
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