#!/bin/bash

BRANCH=$1

echo "BRANCH: ${BRANCH}"

PARENT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

# Determines settings from the provided branch name
function set_settings_from_branch {
    case $BRANCH in
        "development")
            IP=165.232.82.168
            NODE_ENV=staging
            DOMAIN=blockchain-api-staging.tonomy.foundation
            ;;
        "testnet")
            IP=64.227.67.205
            NODE_ENV=testnet
            DOMAIN=blockchain-api-testnet.pangea.web4.world
            ;;
        "master")
            IP=164.90.176.113
            NODE_ENV=production
            DOMAIN=blockchain-api.pangea.web4.world
            ;;
        *)
            echo "Invalid branch name"
            exit 0
            ;;
    esac
}

# Installs prerequisits for running the Tonomy blockchain node
function server_setup_prerequisits {
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

    # nodejs
    wget nodejs.org/dist/v18.12.1/node-v18.12.1-linux-x64.tar.gz
    sudo tar -C /usr/local --strip-components 1 -xzf node-v18.12.1-linux-x64.tar.gz

    echo "enable corepack to use yarn"
    corepack enable

    # make directory for secrets
    mkdir -p /tmp/.secrets/certbot
}

# Installs the Tonomy blockchain node when not already installed
function server_setup_tonomy_first_time {
    # Clone Tonomy-ID-Integration and initialize submoules
    git clone https://github.com/Tonomy-Foundation/Tonomy-ID-Integration.git
    cd Tonomy-ID-Integration
    git checkout "${BRANCH}"
    ./app.sh gitinit "${BRANCH}"
    ./app.sh install
    ./app.sh init
}

# Copies the nginx.conf file and the cloudflare.ini file to the server
# Run on local machine
function local_copy_files_to_server {
    # Replace all instance of {{DOMAIN}} in nginx.conf with the DOMANI env variable
    cp ./nginx.conf ./nginx.conf.bak
    sed -i "s/{{DOMAIN}}/${DOMAIN}/g" ./nginx.conf    
    scp ./nginx.conf root@${IP}:/etc/nginx/conf.d/default.conf
    scp ./cloudflare.ini root@${IP}:/tmp/.secrets/certbot/cloudflare.ini
    cp ./nginx.conf.bak ./nginx.conf
}

# Setup SSL certificate. Need to copy the nginx.conf file and the cloudflare.ini file to the server first.
function server_setup_ssl {
    sudo apt install -y certbot python3-certbot-dns-cloudflare
    certbot certonly --agree-tos -m developers@tonomy.foundation --dns-cloudflare --dns-cloudflare-credentials /tmp/.secrets/certbot/cloudflare.ini -d "${DOMAIN}" --non-interactive
    rm /tmp/.secrets/certbot/cloudflare.ini

    sudo apt install -y nginx
    sudo systemctl restart nginx
}

function server_reset {
    cd Tonomy-ID-Integration
    ./app.sh stop
    git pull
    ./app.sh gitinit "${BRANCH}"
    ./app.sh reset all
    ./app.sh install
    ./app.sh init
}

function server_setup {
    server_setup_prerequisits
    server_setup_tonomy_first_time
    local_copy_files_to_server
    server_setup_ssl
}

function ssh_to_server {
    ssh -v "root@${IP}"
}

set_settings_from_branch