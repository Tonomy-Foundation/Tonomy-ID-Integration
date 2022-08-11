#!/bin/bash

set -u ## exit if you try to use an uninitialised variable
set -e ## exit if any statement fails

# Make sure working dir is same as this dir, so that script can be excuted from another working directory
PARENT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

echo "Resetting blockchain state and history"

TIME1=$(date +%s)

cd "${PARENT_PATH}/../Tonomy-Contracts/contracts/eosio.boot"
if [ -e eosio.boot.wasm ]
then
    echo "eosio.boot already built"
else
    ./build.sh
fi

cd "${PARENT_PATH}/../Tonomy-Contracts/contracts/eosio.bios"
if [ -e eosio.bios.wasm ]
then
    echo "eosio.bios already built"
else
    ./build.sh
fi

cd "${PARENT_PATH}/../Tonomy-Contracts/contracts/eosio.token"
if [ -e eosio.token.wasm ]
then
    echo "eosio.token already built"
else
    ./build.sh
fi

# make sure we have waited at least 10 seconds so that blockchain node starts making blocks
TIME2=$(date +%s)
SLEEP_FOR=$((10 - (TIME2 - TIME1) ))
if [ $SLEEP_FOR -lt 0 ]
then
    SLEEP_FOR=0
fi

echo "Waiting 10 seconds for blockchain node to start"
sleep "${SLEEP_FOR}"

# Start initializing some features of the blockchain and setup initial accounts
docker-compose exec eosio /bin/bash /var/repo/blockchain/initialize-blockchain.sh
if [ $? -gt 0 ]
then
    exit 1
fi