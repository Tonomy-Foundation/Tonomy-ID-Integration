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

check_status() {
    if wait $1; then
        echo "$2 completed successfully."
    else
        echo_red "Error: $2 failed."
    fi
}

function install {
    ARG1=${1-}

    if [ "${ARG1}" == "sdk" ]; then
        cd "${SDK_PATH}"
        yarn run build
        return
    fi

    echo "Installing Tonomy Contracts"
    cd "$SDK_PATH/Tonomy-Contracts"
    ./blockchain/build-docker.sh > /dev/null 2>&1 &
    contracts_pid=$!

    echo "Installing Tonomy SDK"
    cd "$SDK_PATH"
    yarn install > /dev/null 2>&1 && yarn run build > /dev/null 2>&1 &
    sdk_pid=$!

    echo "Installing Tonomy Communication"
    cd "$SDK_PATH/Tonomy-Communication"
    yarn > /dev/null 2>&1 &
    comm_pid=$!

    echo "Installing Tonomy ID"
    cd "$PARENT_PATH/Tonomy-ID"
    yarn > /dev/null 2>&1 &
    id_pid=$!

    echo "Installing Tonomy App Websites"
    cd "$PARENT_PATH/Tonomy-App-Websites"
    yarn > /dev/null 2>&1 &
    app_pid=$!

    echo "Installing pm2 for use with npx"
    npm i -g pm2 > /dev/null 2>&1 &
    pm2_pid=$!

    echo "Building docker containers"
    cd "$PARENT_PATH"
    docker-compose build > /dev/null 2>&1 &
    docker_pid=$!

    echo_orange "Please wait for all installations to complete before running ./app.sh install again"
    echo "Waiting for installations to complete in parallel"
    check_status $docker_pid "Docker containers"
    check_status $pm2_pid "pm2 installation"
    check_status $contracts_pid "Tonomy Contracts"
    check_status $comm_pid "Tonomy Communication"
    check_status $id_pid "Tonomy ID"
    check_status $app_pid "Tonomy App Websites"
    check_status $sdk_pid "Tonomy SDK"

    echo "Installations complete"
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
    echo "Linking SDK to Tonomy-Communication"
    cd "$SDK_PATH/Tonomy-Communication"
    yarn link "$SDK_PATH"

    echo "Linking SDK to Tonomy-ID"
    cd "$PARENT_PATH/Tonomy-App-Websites"
    yarn link "$SDK_PATH"

    echo "Linking SDK to Tonomy-App-Websites"
    cd "$PARENT_PATH/Tonomy-ID"
    yarn link "$SDK_PATH"

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
    # Set NODE_ENV to local if unset
    set +u
    if [ -z "${NODE_ENV}" ]; then
        export NODE_ENV="local";
    fi
    # Set debug if unset. See https://www.npmjs.com/package/debug
    if [ -z "${DEBUG}" ]; then
        export DEBUG="tonomy*";
    fi
    set -u

    # Expo prefix variables
    export EXPO_NODE_ENV="${NODE_ENV}"
    echo "NODE_ENV=${NODE_ENV}"
    echo "EXPO_NODE_ENV=${EXPO_NODE_ENV}"

    # Application variables
    export BLOCKCHAIN_URL="http://${ip}:8888"
    export SSO_WEBSITE_ORIGIN="http://${ip}:3000"
    export ACCOUNTS_SERVICE_URL="http://${ip}:5000"
    export HCAPTCHA_SITE_KEY="10000000-ffff-ffff-ffff-000000000001"

    # Vite prefix variables    
    export VITE_DEBUG="${DEBUG}"
    export VITE_APP_NODE_ENV="${NODE_ENV}";
    export VITE_COMMUNICATION_URL="ws://${ip}:5000"
    export VITE_SSO_WEBSITE_ORIGIN="${SSO_WEBSITE_ORIGIN}"
    export VITE_BLOCKCHAIN_URL="${BLOCKCHAIN_URL}"

    startdocker

    echo "Starting Tonomy-ID-SDK"
    cd "$SDK_PATH"
    npx pm2 start yarn --name "sdk" -- run start

   
    echo "Starting Tonomy-ID"
    cd "${PARENT_PATH}/Tonomy-ID"
    npx pm2 start yarn --name "id" -- run start

    echo "Starting Tonomy-App-Websites"
    cd "${PARENT_PATH}/Tonomy-App-Websites"
    BROWSER=none npx pm2 start yarn --name "apps" -- run dev --host

    echo "Starting communication microservice"
    cd  "$SDK_PATH/Tonomy-Communication"
    npx pm2 start yarn --name "micro" -- run start

    printservices
}

function test {
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
    npx pm2 stop all || true
    npx pm2 delete all || true
}

function reset {
    ARG1=${1-default}

    set +e
    docker volume rm antelope-data

    npx pm2 stop all
    npx pm2 delete all
    set -e
    
    if [ "${ARG1}" == "all" ]
    then
        directories=(
            "${SDK_PATH}"
            "${SDK_PATH}/Tonomy-Communication"
            "${PARENT_PATH}/Tonomy-ID"
            "${PARENT_PATH}/Tonomy-App-Websites"
        )

        to_delete=(
            "node_modules"
            ".pnp.js"
            ".pnp.cjs"
            ".expo"
            ".yarn"
            "yarn-error.log"
            "dist"
            "build"
        )

        # Iterate through each directory
        for dir in "${directories[@]}"; do
            echo "Processing directory: $dir"

            for item in "${to_delete[@]}"; do
                # Delete item if it exists
                if [ -d "$dir/$item" ] || [ -f "$dir/$item" ]; then
                    echo "Deleting $dir/$item"
                    rm -rf "$dir/$item"
                fi
            done
        done
        deletecontracts
    fi

}

function log {
    SERVICE=${1-default}

    if [ "${SERVICE}" == "antelope" ]; then
        docker-compose logs -f antelope
    elif [ "${SERVICE}" == "id" ]; then
        npx pm2 log --lines 20 id
    elif [ "${SERVICE}" == "sdk" ]; then
        npx pm2 log sdk
    elif [ "${SERVICE}" == "linking" ]; then
        npx pm2 log linking
    elif [ "${SERVICE}" == "nginx" ]; then
        tail -f --lines=10 /var/log/nginx/access.log
    elif [ "${SERVICE}" == "apps" ]; then
        npx pm2 log apps
    elif [ "${SERVICE}" == "micro" ]; then
        npx pm2 log micro
    else
        loghelp
    fi
}