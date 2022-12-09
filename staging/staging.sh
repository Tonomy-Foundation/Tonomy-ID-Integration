#!/bin/bash

# Commands for the staging server

# Install a Digital Ocean droplet
# https://cloud.digitalocean.com/droplets/new?i=634b1f&size=s-2vcpu-2gb&region=ams3&options=install_agent
# - Ubuntu 22.04 LTS
# - general 2 vCPU, 2GB RAM
# - 100GB SSD


# Clone Tonomy-ID-Integration and initialize submoules
git clone https://github.com/Tonomy-Foundation/Tonomy-ID-Integration.git
cd Tonomy-ID-Integration
git checkout development
./app.sh gitinit


# Install prerequisits
## Run instructions in ../scripts/install_prerequisits.sh

## install nodejs manually, as the nvm installation doesnt work with root user
wget nodejs.org/dist/v16.4.1/node-v16.4.1-linux-x64.tar.gz
sudo tar -C /usr/local --strip-components 1 -xzf node-v16.4.1-linux-x64.tar.gz

## lsync, rsync, eas, expo and pm2 are not needed
./scripts/install_prerequisits.sh


./app.sh install
./app.sh init


# To reset
cd Tonomy-ID-Integration
./apps.sh stop
git pull
./apps.sh init





# Setup SSL

sudo apt install -y nginx
cp ./nginx.conf /etc/nginx/conf.d/default.conf
sudo systemctl restart nginx#

# Generate a new Cloudflare origin certificate, or use your existing one
# https://dash.cloudflare.com/62eb32c324aaeaeaecc751b529bfb23a/tonomy.foundation/ssl-tls/origin
# Install the Cloudflare Origin SSL certificate *.tonomy.foundation in the /etc/ssl/cert.pem and /etc/ssl/cert.file

# In Cloudflare, add a new proxied A record blockchain-api-staging.tonomy.foundation and point it to the IP of the droplet.

