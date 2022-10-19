#!/bin/bash

function gitinit {
    cd "$PARENT_PATH"
    git submodule init
    git submodule update

    cd "$PARENT_PATH/Tonomy-ID-SDK"
    git checkout development
    git pull

    cd "$PARENT_PATH/Tonomy-ID"
    git checkout development
    git pull

    cd "$PARENT_PATH/Tonomy-ID-Demo"
    git checkout development
    git pull

    cd "$PARENT_PATH/Tonomy-Contracts"
    git checkout development
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
    npm link "$PARENT_PATH/Tonomy-ID-SDK"
 
    cd "$PARENT_PATH/Tonomy-ID-Demo"
    npm install
    npm link "$PARENT_PATH/Tonomy-ID-SDK"

    cd "$PARENT_PATH"
    npm install
    npm link "$PARENT_PATH/Tonomy-ID-SDK"
}

function buildcontracts {
    cd "$PARENT_PATH/Tonomy-Contracts"
    ./build-contracts.sh
}

function init {
    cd "$PARENT_PATH/blockchain"
    echo "Waiting 8 seconds for blockchain node to start"
    sleep 8
    docker-compose exec eosio /bin/bash /var/repo/blockchain/initialize-blockchain.sh

    cd "$PARENT_PATH"
    npm run build
    npm run bootstrap
}

function startdocker {
    echo "Starting Docker compose"
    cd "$PARENT_PATH"
    docker volume create --name=eosio-data
    docker-compose up -d
}

function start {
    set +u
    if [ -z "${NODE_ENV}" ]
    then
        NODE_ENV=development;
    fi
    set -u

    startdocker

    echo "Starting Tonomy-ID-SDK"
    cd "$PARENT_PATH/Tonomy-ID-SDK"
    pm2 start npm --name "sdk" -- run start
 
    # Link Tonomy ID to use the SDK
    # workaround for not being able to use `npm link` to the SDK. see https://stackoverflow.com/a/48987307
    rm -R "${PARENT_PATH}/Tonomy-ID/node_modules/tonomy-id-sdk"
    wml add "${PARENT_PATH}/Tonomy-ID-SDK" "${PARENT_PATH}/Tonomy-ID/node_modules/tonomy-id-sdk"
    pm2 start wml --name "linking" -- start
    
    echo "Starting Tonomy-ID"
    cd "${PARENT_PATH}/Tonomy-ID"
    echo "NODE_ENV=${NODE_ENV}"
    sleep 60 # needed to wait for the linking to finish
    if [ "$NODE_ENV" = "development" ]
    then
        pm2 start npm --name "id" -- run start
    else
        pm2 start npm --name "id" -- run start --tunnel
    fi

    echo "Starting Tonomy-ID-Demo"
    cd "${PARENT_PATH}/Tonomy-ID-Demo"
    npm link "${PARENT_PATH}/Tonomy-ID-SDK"
    BROWSER=none pm2 start npm --name "demo" -- start
}

function stop {
    cd "${PARENT_PATH}"
    set +e
    docker-compose exec eosio /bin/bash /bin/nodeos-stop.sh
    set -e

    docker-compose down

    echo "Stopping npm apps (ID and Demo)"
    set +e
    pm2 delete id
    pm2 delete demo
    pm2 delete sdk
    pm2 delete linking
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
    ARG1=${1-default}

    set +e
    docker volume rm eosio-data

    pm2 delete id
    pm2 delete sdk
    pm2 delete linking
    pm2 delete demo
    set -e
    
    if [ "${ARG1}" == "all" ]
    then
        echo "Deleting all node_modules"
        rm -R "${PARENT_PATH}/Tonomy-ID-SDK/node_modules"
        rm -R "${PARENT_PATH}/Tonomy-ID-SDK/dist"
        rm -R "${PARENT_PATH}/Tonomy-ID/node_modules"
        rm -R "${PARENT_PATH}/Tonomy-ID-Demo/node_modules"
        rm -R "${PARENT_PATH}/node_modules"
    fi

}

function test {
    ARG1=${1-default}

    cd "$PARENT_PATH/Tonomy-ID-SDK"
    npm run prepare

    cd "${PARENT_PATH}"
    npm test

    if [ "${ARG1}" == "all" ]
    then
        echo "Running unit tests"
        cd "$PARENT_PATH/Tonomy-ID-SDK"
        npm run test

        echo "Running unit tests"
        cd "$PARENT_PATH/Tonomy-ID"
        npm run test -- --all
    fi
}

function log {
    SERVICE=${1-default}

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
    elif [ "${SERVICE}" == "nginx" ]; then
        tail -f --lines=10 /var/log/nginx/access.log
    else
        loghelp
    fi
}