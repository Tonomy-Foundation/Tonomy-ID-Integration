#!/bin/bash

function gitinit {
    cd "$PARENT_PATH"
    git submodule init
    git submodule update

    cd "$PARENT_PATH/Tonomy-ID-SDK"
    git checkout master

    cd "$PARENT_PATH/Tonomy-ID"
    git checkout master

    cd "$PARENT_PATH/Tonomy-ID-Demo"
    git checkout master
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
}

function stop {
    cd "$PARENT_PATH"
    set +e
    docker-compose exec eosio /bin/bash /bin/nodeos-stop.sh
    set -e
    
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
    elif [ "$SERVICE" == "tonomy-id-demo" ]; then
        docker-compose logs -f tonomy-id-demo
    else
        echo "Unknown service: $SERVICE"
    fi
}