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

    cd "$PARENT_PATH/Tonomy-ID-SSO-Website"
    git checkout development
    git pull
    
    cd "$PARENT_PATH/Tonomy-ID-Demo-market.com"
    git checkout development
    git pull

    cd "$PARENT_PATH/Tonomy-Contracts"
    git checkout development
    git pull
}

function install {
    ARG1=${1-default}

    if [ "${ARG1}" == "sdk" ]
    then
        cd "$PARENT_PATH/Tonomy-ID-SDK"
        npm run prepare
        return
    fi

    cd "$PARENT_PATH/Tonomy-Contracts"
    ./blockchain/build-docker.sh

    cd "$PARENT_PATH/Tonomy-ID-SDK"
    npm install

    cd "$PARENT_PATH/Tonomy-ID"
    npm install

    cd "$PARENT_PATH/Tonomy-ID-SSO-Website"
    npm install

    cd "$PARENT_PATH/Tonomy-ID-Demo-market.com"
    npm install
}

function deletecontracts {
    cd "$PARENT_PATH/Tonomy-Contracts"
    ./delete-buildt-contracts.sh
}

function init {
    cd "$PARENT_PATH/Tonomy/Contracts/blockchain"
    echo "Waiting 8 seconds for blockchain node to start"
    sleep 8

    cd "$PARENT_PATH"
    npm run bootstrap

    echo ""
    echo ""
    echo "Blockchain running and initialized"
    echo ""
    echo "To start Tonomy ID run: ./app.sh start"
}

function startdocker {
    echo "Starting Docker compose"
    cd "$PARENT_PATH"
    docker volume create --name=antelope-data
    docker-compose up -d
}

getIpAddress() {
    hostname -I | head -n1 | awk '{print $1;}'
}

function start {
    ARG1=${1-default}
    set +u
    if [ -z "${NODE_ENV}" ]
    then
        export NODE_ENV="local";
        export REACT_APP_NODE_ENV="local";
    fi
    set -u

    startdocker

    ip=`getIpAddress`

    echo "Starting Tonomy-ID-SDK"
    cd "$PARENT_PATH/Tonomy-ID-SDK"
    pm2 start npm --name "sdk" -- run start

    echo "Starting Tonomy-ID"
    cd "${PARENT_PATH}/Tonomy-ID"
    echo "NODE_ENV=${NODE_ENV}"

    export BLOCKCHAIN_URL="http://${ip}:8888"
    export SSO_WEBSITE_ORIGIN="http://${ip}:3000"
    pm2 start npm --name "id" -- run start

    if [ "${ARG1}" == "all" ]
    then
        export REACT_APP_SSO_WEBSITE_ORIGIN="${SSO_WEBSITE_ORIGIN}"
        export REACT_APP_BLOCKCHAIN_URL="${BLOCKCHAIN_URL}"
        
        echo "Starting Tonomy-ID-SSO-Website"
        cd "${PARENT_PATH}/Tonomy-ID-SSO-Website"
        BROWSER=none pm2 start npm --name "sso" -- start

        echo "Starting Tonomy-ID-Demo-market.com"
        cd "${PARENT_PATH}/Tonomy-ID-Demo-market.com"
        BROWSER=none pm2 start npm --name "market" -- start
    fi

    printservices
    if [ "${ARG1}" == "all" ]
    then
        printWebsiteServices
    fi
}

function stop {
    cd "${PARENT_PATH}"
    docker-compose exec antelope ./nodeos.sh stop || true

    docker-compose down

    echo "Stopping npm apps (ID and Demo)"
    set +e
    pm2 stop all
    pm2 delete all
    set -e
}

function reset {
    ARG1=${1-default}

    set +e
    docker volume rm antelope-data

    pm2 stop all
    pm2 delete all
    set -e
    
    if [ "${ARG1}" == "all" ]
    then
        echo "Deleting all node_modules"
        set +e
        rm -R "${PARENT_PATH}/Tonomy-ID-SDK/node_modules"
        rm -R "${PARENT_PATH}/Tonomy-ID-SDK/dist"
        rm -R "${PARENT_PATH}/Tonomy-ID/node_modules"
        rm -R "${PARENT_PATH}/Tonomy-ID/.expo"
        rm -R "${PARENT_PATH}/Tonomy-ID-SSO-Website/node_modules"
        rm -R "${PARENT_PATH}/Tonomy-ID-Demo-market.com/node_modules"
        set -e
        deletecontracts
    fi

}

function log {
    SERVICE=${1-default}

    if [ "${SERVICE}" == "antelope" ]; then
        docker-compose logs -f antelope
    elif [ "${SERVICE}" == "id" ]; then
        pm2 log --lines 20 id
    elif [ "${SERVICE}" == "sso" ]; then
        pm2 log sso
    elif [ "${SERVICE}" == "sdk" ]; then
        pm2 log sdk
    elif [ "${SERVICE}" == "linking" ]; then
        pm2 log linking
    elif [ "${SERVICE}" == "nginx" ]; then
        tail -f --lines=10 /var/log/nginx/access.log
    elif [ "${SERVICE}" == "market" ]; then
        pm2 log market
    else
        loghelp
    fi
}