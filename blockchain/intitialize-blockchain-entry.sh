#!/bin/bash

set -u ## exit if you try to use an uninitialised variable
set -e ## exit if any statement fails

# Make sure working dir is same as this dir, so that script can be excuted from another working directory
PARENT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$PARENT_PATH"

echo "Resetting blockchain state and history"

cd "${PARENT_PATH}/contracts/eosio.boot"
if [ -e eosio.boot.wasm ]
then
    echo "eosio.boot already built"
else
    ./build.sh
fi

cd "${PARENT_PATH}/contracts/eosio.bios"
if [ -e eosio.bios.wasm ]
then
    echo "eosio.bios already built"
else
    ./build.sh
fi

# allow for block production to start
echo "Waiting for blockchain node to start"
sleep 5

docker-compose exec eosio /bin/bash /var/repo/blockchain/initialize-blockchain.sh
if [ $? -gt 0 ]
then
    exit 1
fi