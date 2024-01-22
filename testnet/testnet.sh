#!/bin/bash

# Commands for the testnet server

# Install a Digital Ocean droplet
# https://cloud.digitalocean.com/droplets/new?i=634b1f&size=s-2vcpu-2gb&region=ams3&options=install_agent
# - Ubuntu 22.04 LTS
# - general 2 vCPU, 2GB RAM
# - 100GB SSD


# Clone Tonomy-ID-Integration and initialize submoules
git clone https://github.com/Tonomy-Foundation/Tonomy-ID-Integration.git
cd Tonomy-ID-Integration
git checkout testnet
./app.sh gitinit testnet


# Install prerequisits
## Run instructions in ../scripts/install_prerequisits.sh
./scripts/install_prerequisits.sh

## install nodejs manually, as the nvm installation doesnt work with root user
wget nodejs.org/dist/v18.12.1/node-v18.12.1-linux-x64.tar.gz
sudo tar -C /usr/local --strip-components 1 -xzf node-v18.12.1-linux-x64.tar.gz
corepack enable
# pm2 not needed as we only need to run the blockchain-api

# Setup SSL
sudo apt install -y nginx
cp ./Tonomy-ID-Integration/testnet/nginx.conf /etc/nginx/conf.d/default.conf
sudo systemctl restart nginx

# Generate a new Cloudflare origin certificate, or use your existing one
# https://dash.cloudflare.com/62eb32c324aaeaeaecc751b529bfb23a/tonomy.foundation/ssl-tls/origin
# Install the Cloudflare Origin SSL certificate *.tonomy.foundation in the /etc/ssl/cert.pem and /etc/ssl/cert.key

# In Cloudflare, add a new proxied A record blockchain-api-testnet.pangea.web4.world and point it to the IP of the droplet.

# Install, run and initialize the blockchain-api
cd Tonomy-ID-Integration
./app.sh install
export NODE_ENV=testnet
./app.sh init

# To reset
cd Tonomy-ID-Integration
./apps.sh stop
git pull
./app.sh gitinit testnet
./app.sh reset all
./app.sh install
export NODE_ENV=testnet
./apps.sh init

