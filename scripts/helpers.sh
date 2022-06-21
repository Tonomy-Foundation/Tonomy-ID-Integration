#!/bin/bash

function gitinit {
    cd "$PARENT_PATH"
    git submodule init
    git submodule update
}

function install {
    gitinit
    
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
    ./init_reset_eosio.sh
}

function start {
    cd "$PARENT_PATH"
    docker volume create --name=eosio-data
    docker-compose up -d
}

function stop {
    cd "$PARENT_PATH"
    set +e
    docker-compose exec eosio /bin/bash /bin/stop.sh
    set -e
    
    docker-compose down
}

function reset {
    set +e
    docker volume rm eosio-data
    set -e
}