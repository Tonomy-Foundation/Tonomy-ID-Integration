#!/bin/bash

# Ubuntu 20 machine


echo "Run this script manually, as you need to reboot and exit terminal during installation."
echo "Press any key to exit..."
read var
exit

sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y

# Docker 20.10.17 and docker-compose 1.29.2
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04
sudo apt install apt-transport-https ca-certificates software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt install docker-ce=5:20.10* -y
sudo usermod -aG docker ${USER}
reboot now

# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
exit
echo "Setting up to use node v16.4.1"
nvm install v16.4.1
nvm alias default v16.4.1

echo "Installing pm2 globally"
npm i -g pm2@5.2.0
