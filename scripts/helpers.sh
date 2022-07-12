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
    #nvm install v16.4.1
    #nvm alias default v16.4.1

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

    echo "Starting Tonomy-ID-Demo"
    cd "${PARENT_PATH}/Tonomy-ID-Demo"
    BROWSER=none npm start &>> demo.log &
}

function stop {
    cd "${PARENT_PATH}"
    set +e
    docker-compose exec eosio /bin/bash /bin/nodeos-stop.sh
    set -e
    
    docker-compose down

    echo "Stopping all node processes. May not be the best way to do this. But it works."
    set +e
    nodeprocesses=`pidof node`
    if [[ ! -z "${nodeprocesses}" ]]; then
        kill -9  ${nodeprocesses}
    fi
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
    elif [ "${SERVICE}" == "emulator" ]; then
        docker-compose logs -f emulator
    elif [ "${SERVICE}" == "id" ]; then
        docker-compose logs -f id
    elif [ "${SERVICE}" == "demo" ]; then
        tail -f "${PARENT_PATH}/Tonomy-ID-Demo/demo.log"
    else
        loghelp
    fi
}