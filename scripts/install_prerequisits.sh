#!/bin/bash

# Ubuntu 20 machine


# NEEDS prerequisite check
# Does the server have enough RAM? 
# Is the user calling this root?
# Is this Ubuntu 20.04 ?

sudo apt install npm git htop -y

#Nodejs??

#dialog --backtitle "TONOMY INTERGRATION MODULE" \
#       --title "Configuration sun-java-jre" \
#       --yesno "\nThis will install all prerequisites to run the tonomy network. This is a test network and prototype, we are not responsible for your data\n\nDo you accept?" 10 30

#echo "Run this script manually, as you need to reboot and exit terminal during installation."
#echo "Press any key to exit..."
#read var
#exit

sudo apt update -y && sudo apt upgrade -y && sudo autoremove -y

# Docker 20.10.17 and docker-compose 1.29.2
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04
sudo apt install apt-transport-https ca-certificates software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt install docker-ce=5:20.10.17~3-0~ubuntu-focal -y
sudo usermod -aG docker ${USER}
#sudo shutdown now
# you can't shutdown a server like this, we might never get access to it again. Also this interrupts the script! 
# Find a way to reboot services instead. 

# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# watchman
sudo apt-get install watchman=4.9.0-3build1 -y

# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
#exit
echo "Setting up to use node v16.4.1"
nvm install v16.4.1
nvm alias default v16.4.1

echo "Installing pm2 globally"
npm i -g pm2@5.2.0
echo "Installing Expo-CLI globally"
npm i -g expo-cli@5.5.1
echo "Installing TSDX globally"
npm i -g tsdx@0.14.1
echo "Intalling  wml globally"
npm i -g wml@0.0.83
echo "Intalling  eas-cli globally"
npm i -g eas-cli@2.2.1
