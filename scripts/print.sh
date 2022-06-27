#!/bin/bash

function help {
    echo ""
    echo "Usage:"
    echo "    app.sh [commands]"
    echo ""
    echo "Commands:"
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
    echo "Blockchain (eosio) node - http://localhost:8888/v1/chain/get_info"
    echo "Blockchain explorer     - https://local.bloks.io/?nodeUrl=http%3A%2F%2Flocalhost%3A8888&coreSymbol=SYS&systemDomain=eosio"
    echo "" 
    echo ""
    echo ""
}