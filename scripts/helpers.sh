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
    cd "$PARENT_PATH"
    docker-compose build

    cd "$PARENT_PATH/Tonomy-ID-SDK"
    npm install

    cd "$PARENT_PATH/Tonomy-ID"
    npm install

    cd "$PARENT_PATH/Tonomy-ID-Demo"
    npm install
}

function init {
    cd "$PARENT_PATH/blockchain"
    ./intitialize-blockchain-entry.sh
}

function start {
    cd "$PARENT_PATH"
    docker volume create --name=eosio-data
    docker-compose up -d
    cd "$PARENT_PATH/Tonomy-ID"
    npm run start
    
}

function stop {
    cd "$PARENT_PATH"
    docker-compose down
}

function reset {
    set +e
    docker volume rm eosio-data
    set -e
}

function log {
    SERVICE=${1}

    if [ "$SERVICE" == "eosio" ]; then
        docker-compose logs -f eosio
    elif [ "$SERVICE" == "emulator" ]; then
        docker-compose logs -f emulator
    elif [ "$SERVICE" == "id" ]; then
        docker-compose logs -f id
    elif [ "$SERVICE" == "demo" ]; then
        docker-compose logs -f demo
    else
        loghelp
    fi
}