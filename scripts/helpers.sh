#!/bin/bash

function install {
    cd "$PARENT_PATH"
    git submodule update
    
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
    docker-compose up -d
}

function stop {
    cd "$PARENT_PATH"
    docker exec -it eosio pkill nodeos
    docker-compose down
}

function reset {
    echo "TODO"
}