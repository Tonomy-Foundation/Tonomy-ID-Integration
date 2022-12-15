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

    echo "Installing docker containers"
    cd "$PARENT_PATH"
    docker-compose build

    cd "$PARENT_PATH/Tonomy-ID-SDK"
    npm install

    cd "$PARENT_PATH/Tonomy-ID"
    npm install

    cd "$PARENT_PATH/Tonomy-ID-SSO-Website"
    npm install
    npm link "$PARENT_PATH/Tonomy-ID-SDK"

    cd "$PARENT_PATH/Tonomy-ID-Demo-market.com"
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

getIpAddress() {
    hostname -I | head -n1 | awk '{print $1;}'
}
ip=`getIpAddress`

function start {
    ARG1=${1-default}
    set +u
    if [ -z "${NODE_ENV}" ]
    then
        export NODE_ENV="local";
    fi
    set -u

    startdocker
    
    echo "Starting Tonomy-ID-SDK"
    cd "$PARENT_PATH/Tonomy-ID-SDK"
    pm2 start npm --name "sdk" -- run start

    echo "Starting Tonomy-ID"
    cd "${PARENT_PATH}/Tonomy-ID"
    echo "NODE_ENV=${NODE_ENV}"

    export BLOCKCHAIN_URL="http://${ip}:8888"
    pm2 start npm --name "id" -- run start

    if [ "${ARG1}" == "all" ]
    then
        export REACT_APP_SSO_WEBSITE_ORIGIN="http://${ip}:3000"
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
        rm -R "${PARENT_PATH}/Tonomy-ID-Demo-market.com/node_modules"
        rm -R "${PARENT_PATH}/node_modules"

        deletecontracts
    fi

}

function test {
    ARG1=${1-default}

    cd "$PARENT_PATH/Tonomy-ID-SDK"
    npm run prepare

    cd "${PARENT_PATH}"
    if [ "${ARG1}" == "all" ]
    then
        npm test
    else
        npm test "${ARG1}"
    fi

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