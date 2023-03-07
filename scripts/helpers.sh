#!/bin/bash

SDK_PATH="$PARENT_PATH/Tonomy-ID-SDK"

function gitinit {
    cd "$PARENT_PATH"
    git submodule update --init --recursive
    git submodule foreach --recursive git checkout development
    git submodule foreach --recursive git pull
}

function install {
    ARG1=${1-default}

    if [ "${ARG1}" == "sdk" ]
    then
        cd "$SDK_PATH"
        npm run prepare
        return
    fi

    cd "$SDK_PATH/Tonomy-Contracts"
    ./blockchain/build-docker.sh

    cd "$SDK_PATH/Tonomy-Communication"
    yarn install

    cd "$SDK_PATH"
    npm install

    cd "$PARENT_PATH/Tonomy-ID"
    npm install

    cd "$PARENT_PATH/Tonomy-App-Websites"
    yarn install
}

function deletecontracts {
    cd "$PARENT_PATH/Tonomy-Contracts"
    ./delete-buildt-contracts.sh
}

function init {
    echo "Waiting 8 seconds for blockchain node to start"
    sleep 8

    cd "$SDK_PATH"
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

function start {
    ARG1=${1-default}
    set +u
    if [ -z "${NODE_ENV}" ]
    then
        export NODE_ENV="local";
        export VITE_APP_NODE_ENV="local";
    fi
    set -u

    startdocker

    echo "Starting Tonomy-ID-SDK"
    cd "$SDK_PATH"
    pm2 start npm --name "sdk" -- run start

    echo "Starting Tonomy-ID"
    cd "${PARENT_PATH}/Tonomy-ID"
    echo "NODE_ENV=${NODE_ENV}"

    export BLOCKCHAIN_URL="http://${ip}:8888"
    export SSO_WEBSITE_ORIGIN="http://sso.${ip}:5173"
    export VITE_COMMUNICATION_URL="ws://${ip}:5000"
    pm2 start npm --name "id" -- run start

    if [ "${ARG1}" == "all" ]
    then
        export VITE_SSO_WEBSITE_ORIGIN="${SSO_WEBSITE_ORIGIN}"
        export VITE_BLOCKCHAIN_URL="${BLOCKCHAIN_URL}"
        
        echo "Starting Tonomy-App-Websites"
        cd "${PARENT_PATH}/Tonomy-App-Websites"
        BROWSER=none pm2 start yarn --name "apps" -- dev --host

        echo "Starting communication microservice"
        cd  "$SDK_PATH/Tonomy-Communication"
        pm2 start yarn --name "micro" -- run start:dev
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
        rm -R "$SDK_PATH/node_modules"
        rm -R "${SDK_PATH}/Tonomy-Communication/node_modules" 
        rm -R "${PARENT_PATH}/Tonomy-ID-SDK/dist"
        rm -R "${PARENT_PATH}/Tonomy-ID/node_modules"
        rm -R "${PARENT_PATH}/Tonomy-ID/.expo"
        rm -R "${PARENT_PATH}/Tonomy-App-Websites/node_modules"
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
    elif [ "${SERVICE}" == "sdk" ]; then
        pm2 log sdk
    elif [ "${SERVICE}" == "linking" ]; then
        pm2 log linking
    elif [ "${SERVICE}" == "nginx" ]; then
        tail -f --lines=10 /var/log/nginx/access.log
    elif [ "${SERVICE}" == "apps" ]; then
        pm2 log apps
    elif [ "${SERVICE}" == "micro" ]; then
        pm2 log micro
    else
        loghelp
    fi
}