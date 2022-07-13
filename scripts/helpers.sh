#!/bin/bash

function gitinit {
    cd "$PARENT_PATH"
    git submodule init
    git submodule update

    cd "$PARENT_PATH/Tonomy-ID-SDK"
    git checkout master
    git pull

    cd "$PARENT_PATH/Tonomy-ID"
    git checkout master
    git pull

    cd "$PARENT_PATH/Tonomy-ID-Demo"
    git checkout master
    git pull
}

function install {
    echo "Installing docker containers"
    cd "$PARENT_PATH"
    docker-compose build

    echo "Setting up to use node v16.4.1"
    #nvm install v16.4.1
    #nvm alias default v16.4.1
    echo "Installing pm2 globally"
    npm i -g pm2
    echo "Installing Expo-CLI globally"
    npm i -g expo-cli

    cd "$PARENT_PATH/Tonomy-ID-SDK"
    npm install

    cd "$PARENT_PATH/Tonomy-ID"
    npm install

    cd "$PARENT_PATH/Tonomy-ID-Demo"
    npm install

    mkdir "$PARENT_PATH/tmp"
}

function init {
    cd "$PARENT_PATH/blockchain"
    ./intitialize-blockchain-entry.sh
}

function start {
    echo "Starting Docker compose"
    cd "$PARENT_PATH"
    docker volume create --name=eosio-data
    docker-compose up -d

    echo "Starting Tonomy-ID"
    cd "${PARENT_PATH}/Tonomy-ID"
    pm2 start expo --name "id" -- start --host localhost
    #pm2 start expo --name "id" -- start --host tunnel

    echo "Starting Tonomy-ID-Demo"
    cd "${PARENT_PATH}/Tonomy-ID-Demo"
    pm2 start npm --name "demo" -- start
}

function stop {
    cd "${PARENT_PATH}"
    set +e
    docker-compose exec eosio /bin/bash /bin/nodeos-stop.sh
    set -e
    
    docker-compose down

    echo "Stopping npm apps (ID and Demo)"
    set +e
    pm2 delete id demo
    set -e
}

function reset {
    set +e
    docker volume rm eosio-data
    set -e
}

function log {
    SERVICE=${1}

    if [ "${SERVICE}" == "eosio" ]; then
        docker-compose logs -f eosio
    elif [ "${SERVICE}" == "id" ]; then
        pm2 log id
    elif [ "${SERVICE}" == "demo" ]; then
        pm2 log demo
    else
        loghelp
    fi
}