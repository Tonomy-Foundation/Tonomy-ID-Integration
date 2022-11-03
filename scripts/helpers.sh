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
    echo "Installed SDK!"
    sleep 2
    if [ ! -d "$PARENT_PATH/Tonomy-ID-SDK/node_modules/babel-eslint" ] || [ ! -f "$PARENT_PATH/Tonomy-ID-SDK/dist/tonomy-id-sdk.cjs.development.js" ]; then
        echo "Error: npm install failed. Trying again..."
        sleep 5
        npm install

        if [ ! -d "$PARENT_PATH/Tonomy-ID-SDK/node_modules/babel-eslint" ] || [ ! -f "$PARENT_PATH/Tonomy-ID-SDK/dist/tonomy-id-sdk.cjs.development.js" ]; then
            echo "Error: npm install failed AGAIN. Try installing manually"
            exit 1
            sleep 5
        fi        
    fi

    cd "$PARENT_PATH/Tonomy-ID"
    npm install
 
    # cd "$PARENT_PATH/Tonomy-ID-Demo"
    # npm install
    # npm link "$PARENT_PATH/Tonomy-ID-SDK"

    cd "$PARENT_PATH"
    npm install
    npm link "$PARENT_PATH/Tonomy-ID-SDK"
}

function buildcontracts {
    cd "$PARENT_PATH/Tonomy-Contracts"
    ./build-contracts.sh
}

function deletecontracts {
    cd "$PARENT_PATH/Tonomy-Contracts"
    ./delte-built-contracts.sh
}

function init {
    cd "$PARENT_PATH/blockchain"
    echo "Waiting 8 seconds for blockchain node to start"
    sleep 8
    docker-compose exec eosio /bin/bash /var/repo/blockchain/initialize-blockchain.sh

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
    echo "linking tonomy id sdk to tonomy id"
    rsync -azcrd "$PARENT_PATH/Tonomy-ID-SDK/" "$PARENT_PATH/Tonomy-ID/node_modules/tonomy-id-sdk"
    pm2 start lsyncd --name "linking" -- -nodaemon --delay 5  -rsync   "$PARENT_PATH/Tonomy-ID-SDK/" "$PARENT_PATH/Tonomy-ID/node_modules/tonomy-id-sdk"
  

    echo "Starting Tonomy-ID"
    cd "${PARENT_PATH}/Tonomy-ID"
    echo "NODE_ENV=${NODE_ENV}"
    if [ "$NODE_ENV" = "development" ]
    then
        pm2 start npm --name "id" -- run start
    else
        # use different command here for staging/production
        pm2 start npm --name "id" -- run start
    fi

    # echo "Starting Tonomy-ID-Demo"
    # cd "${PARENT_PATH}/Tonomy-ID-Demo"
    # npm link "${PARENT_PATH}/Tonomy-ID-SDK"
    # BROWSER=none pm2 start npm --name "demo" -- start
}

function stop {
    cd "${PARENT_PATH}"
    set +e
    docker-compose exec eosio /bin/bash /bin/nodeos-stop.sh
    set -e

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
    docker volume rm eosio-data

    pm2 stop all
    pm2 delete all
    set -e
    
    if [ "${ARG1}" == "all" ]
    then
        echo "Deleting all node_modules"
        rm -R "${PARENT_PATH}/Tonomy-ID-SDK/node_modules"
        rm -R "${PARENT_PATH}/Tonomy-ID-SDK/dist"
        rm -R "${PARENT_PATH}/Tonomy-ID/node_modules"
        rm -R "${PARENT_PATH}/Tonomy-ID-Demo/node_modules"
        rm -R "${PARENT_PATH}/node_modules"

        deletecontracts
    fi

}

function test {
    ARG1=${1-default}

    cd "$PARENT_PATH/Tonomy-ID-SDK"
    npm run prepare

    cd "${PARENT_PATH}"
    npm test "${ARG1}"

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