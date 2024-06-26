#!/bin/bash

SDK_PATH="$PARENT_PATH/Tonomy-ID-SDK"

function gitinit {
    ARG1=${1-}

    if [ "${ARG1}" == "master" ]; then
        BRANCH="master"
    elif [ "${ARG1}" == "testnet" ]; then
        BRANCH="testnet"
    else
        BRANCH="development"
    fi

    cd "$PARENT_PATH"
    git submodule update --init --recursive
    git submodule foreach --recursive git checkout "${BRANCH}"
    git submodule foreach --recursive git pull
    cd "$SDK_PATH" 
    git submodule update --init --recursive
    git submodule foreach --recursive git checkout "${BRANCH}"
    git submodule foreach --recursive git pull
}

function install {
    ARG1=${1-}

    if [ "${ARG1}" == "sdk" ]; then
        cd "${SDK_PATH}"
        yarn run build
        return
    fi

    cd "$SDK_PATH/Tonomy-Contracts"
    ./blockchain/build-docker.sh

    cd "$SDK_PATH"
    yarn install

    cd "$SDK_PATH/Tonomy-Communication"
    yarn

    cd "$PARENT_PATH/Tonomy-ID"
    yarn

    cd "$PARENT_PATH/Tonomy-App-Websites"
    yarn

}

function update {
    ARG1=${1-}

    if [ "${ARG1}" == "master" ]; then
        BRANCH="master"
    elif [ "${ARG1}" == "testnet" ]; then
        BRANCH="testnet"
    else
        BRANCH="development"
    fi

    echo "Updating Tonomoy Communication with @tonomy/tonomy-id-sdk"
    cd "${SDK_PATH}/Tonomy-Communication"
    yarn run updateSdkVersion "${BRANCH}"

    echo "Updating Tonomy ID with @tonomy/tonomy-id-sdk"    
    cd "${PARENT_PATH}/Tonomy-ID"
    yarn run updateSdkVersion "${BRANCH}"

    echo "Updating Tonomy App Websites with @tonomy/tonomy-id-sdk"
    cd "${PARENT_PATH}/Tonomy-App-Websites"
    yarn run updateSdkVersion "${BRANCH}"
}

RED='\033[0;31m'
ORANGE='\033[0;33m'
NOCOLOR='\033[0m'

function echo_red {
    echo -e "${RED}${@}${NOCOLOR}"
}

function echo_orange {
    echo -e "${ORANGE}${@}${NOCOLOR}"
}

function link {
    cd "$SDK_PATH/Tonomy-Communication"
    yarn link "$SDK_PATH"

    cd "$PARENT_PATH/Tonomy-App-Websites"
    yarn link "$SDK_PATH"

    cd "$PARENT_PATH/Tonomy-ID"
    yarn add "$SDK_PATH"

    echo ""
    echo "Linking of clients to SDK complete"
    echo_orange "WARNING: Make sure you DO NOT commit these changes to the repository!"
}

function deletecontracts {
    cd "$PARENT_PATH/Tonomy-ID-SDK/Tonomy-Contracts"
    ./delete-buildt-contracts.sh
}

function init {
    echo "Waiting 8 seconds for blockchain node to start"
    sleep 8

    cd "$SDK_PATH"
    NODE_ENV="${NODE_ENV:-development}"
    if [[ "${NODE_ENV}" == "development" ]]
    then
        echo "Using development environment: setting keys"
        source ./test/export_test_keys.sh
    fi
    yarn run cli bootstrap

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
    ARG1=${1-}
    export LOG="true"
    export VITE_LOG="true"
    set +u
    if [ -z "${NODE_ENV}" ]; then
        export NODE_ENV="local";
        export VITE_APP_NODE_ENV="local";
    fi
    set -u

    startdocker

    echo "Starting Tonomy-ID-SDK"
    cd "$SDK_PATH"
    pm2 start yarn --name "sdk" -- run start

    export EXPO_NODE_ENV="${NODE_ENV}"
    echo "NODE_ENV=${NODE_ENV}"
    echo "EXPO_NODE_ENV=${EXPO_NODE_ENV}"

    export BLOCKCHAIN_URL="http://${ip}:8888"
    export SSO_WEBSITE_ORIGIN="http://${ip}:3000"
    export VITE_COMMUNICATION_URL="ws://${ip}:5000"
    export ACCOUNTS_SERVICE_URL="http://${ip}:5000"
    export HCAPTCHA_SITE_KEY="10000000-ffff-ffff-ffff-000000000001"
    
    export VITE_SSO_WEBSITE_ORIGIN="${SSO_WEBSITE_ORIGIN}"
    export VITE_BLOCKCHAIN_URL="${BLOCKCHAIN_URL}"
    
    echo "Starting Tonomy-ID"
    cd "${PARENT_PATH}/Tonomy-ID"
    pm2 start yarn --name "id" -- run start

    echo "Starting Tonomy-App-Websites"
    cd "${PARENT_PATH}/Tonomy-App-Websites"
    BROWSER=none pm2 start yarn --name "apps" -- run dev --host

    echo "Starting communication microservice"
    cd  "$SDK_PATH/Tonomy-Communication"
    pm2 start yarn --name "micro" -- run start:dev

    printservices
}

function test {
    export LOG="false"
    export NODE_ENV="local"
    export VITE_APP_NODE_ENV="local";

    cd "$SDK_PATH"
    yarn run build
    yarn run lint
    yarn run test:unit
    source ./test/export_test_keys.sh
    yarn run test:setup
    yarn run test:integration
    yarn run test:governance
    yarn run test:setup-down

    cd "$PARENT_PATH/Tonomy-ID"
    yarn run test
    yarn run lint
    yarn run typeCheck
    
    cd "$PARENT_PATH/Tonomy-App-Websites"
    yarn run build

    cd "$SDK_PATH/Tonomy-Communication"
    yarn run build
    yarn run lint
    yarn run test

    cd "$SDK_PATH/Tonomy-Contracts"
    ./build-contracts.sh

    echo "All tests passed"
}

function stop {
    cd "${PARENT_PATH}"
    docker-compose exec antelope ./nodeos.sh stop || true
    docker rm -f tonomy_blockchain_integration || true

    docker-compose down

    echo "Stopping pm2 apps (ID, Apps, Sdk, Micro)"
    pm2 stop all || true
    pm2 delete all || true
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
        echo "Deleting all packages and builds"
        set +e
        rm -R "$SDK_PATH/node_modules"
        rm -R "$SDK_PATH/build"
        rm -R "${SDK_PATH}/Tonomy-Communication/node_modules" 
        rm -R "${SDK_PATH}/Tonomy-Communication/dist" 
        rm -R "${PARENT_PATH}/Tonomy-ID/node_modules"
        rm -R "${PARENT_PATH}/Tonomy-ID/.expo"
        rm -R "${PARENT_PATH}/Tonomy-App-Websites/node_modules"
        rm -R "${PARENT_PATH}/Tonomy-App-Websites/.yarn"
        rm -R "${PARENT_PATH}/Tonomy-App-Websites/dist"
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