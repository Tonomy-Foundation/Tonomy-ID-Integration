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
    echo "Starting Docker compose"
    cd "$PARENT_PATH"
    docker volume create --name=eosio-data
    docker-compose up -d
    cd "$PARENT_PATH/Tonomy-ID"
    npm run start
    
    echo "Starting Tonomy-ID-SDK"
    cd "$PARENT_PATH/Tonomy-ID-SDK"
    pm2 start npm --name "sdk" -- run start

    # workaround for not being able to use `npm link` to the SDK. see https://stackoverflow.com/a/48987307
    wml add "${PARENT_PATH}/Tonomy-ID-SDK" "${PARENT_PATH}/Tonomy-ID/node_modules/tonomy-id-sdk"
    pm2 start wml --name "linking" -- start

    echo "Starting Tonomy-ID"
    cd "${PARENT_PATH}/Tonomy-ID"

    pm2 start npm --name "id" -- start
    # pm2 start expo --name "id" -- start --host tunnel
    echo "Starting Tonomy-ID-Demo"
    cd "${PARENT_PATH}/Tonomy-ID-Demo"
    npm link "${PARENT_PATH}/Tonomy-ID-SDK"
    BROWSER=none pm2 start npm --name "demo" -- start
}

function stop {
    cd "${PARENT_PATH}"
    docker-compose down

    echo "Stopping npm apps (ID and Demo)"
    set +e
    pm2 delete id demo sdk linking
    set -e

    set +e
    echo "Stopping watchman and removing wml links"
    watchman watch-del-all
    watchman watch-del-all
    wml stop
    wml rm all
    set +e
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
        pm2 log --lines 20 id
    elif [ "${SERVICE}" == "demo" ]; then
        pm2 log demo
    elif [ "${SERVICE}" == "sdk" ]; then
        pm2 log sdk

    elif [ "${SERVICE}" == "linking" ]; then
        pm2 log linking
    else
        loghelp
    fi
}