#!/bin/bash

PARENT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

docker run -v "${PARENT_PATH}/contracts/eosio.bios:/tmp"\
    eostudio/eosio.cdt:v1.8.1\
    eosio-cpp\
    -abigen\
    -I /tmp/include\
    -R resource\
    -contract eosio.bios\
    -o /tmp/eosio.bios.wasm\
    /tmp/src/eosio.bios.cpp