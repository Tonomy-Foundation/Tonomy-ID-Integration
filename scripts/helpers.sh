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

    npm link "${PARENT_PATH}/Tonomy-ID-SDK"
}

function init {
    cd "$PARENT_PATH/blockchain"
    ./intitialize-blockchain-entry.sh
}

function start {
    cd "$PARENT_PATH"
    docker volume create --name=eosio-data
    docker-compose up -d
    
    # Let the emulator communicate with the packager (metro) on the id container, thinking that it is at localhost
    # https://unix.stackexchange.com/a/560810
    sleep 20 && docker-compose exec -T emulator socat tcp-listen:8081,bind=localhost,fork tcp:id:8081 &
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