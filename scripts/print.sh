#!/bin/bash

function help {
    echo ""
    echo "Usage:"
    echo "    app.sh [commands]"
    echo ""
    echo "Commands:"
    echo "    gitinit        - initializes all git submodules and checks out master branch"
    echo "    install        - installs all application repositories"
    echo "    init           - starts application components through docker compose and initializes and resets the blockchain and database"
    echo "    start          - starts application components through docker compose"
    echo "    stop           - stops application execution"
    echo "    reset          - stops application execution and resets all data"
    echo "    log [service] - prints logs for the service"
}

function printservices {
    echo "##################################################"
    echo ""
    echo ""
    echo ""
    echo "Services now running:"
    echo ""
    echo "Tonomy ID app (react native) - http://localhost:6080  (go here NOW to open the emulator so that Tonomy ID loads correctly)"
    echo "Tonomy ID Demo app (react)   - http://localhost:3000"
    echo "Blockchain node (eosio)      - http://localhost:8888/v1/chain/get_info"
    echo "Blockchain explorer          - https://local.bloks.io/?nodeUrl=http%3A%2F%2Flocalhost%3A8888&coreSymbol=SYS&systemDomain=eosio"
    echo "" 
    echo ""
    echo ""
}