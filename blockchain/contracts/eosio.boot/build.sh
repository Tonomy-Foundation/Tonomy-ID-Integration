#!/bin/bash

PARENT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

DOCKER_WORKING_DIR="/tmp"
CONTRACT_NAME="eosio.boot"
docker run -v "${PARENT_PATH}/contracts/${CONTRACT_NAME}:${DOCKER_WORKING_DIR}"\
    eostudio/eosio.cdt:v1.8.1\
    eosio-cpp\
    -abigen\
    -I "${DOCKER_WORKING_DIR}"/include\
    -R resource\
    -contract "${CONTRACT_NAME}"\
    -o "${DOCKER_WORKING_DIR}/${CONTRACT_NAME}.wasm"\
    "${DOCKER_WORKING_DIR}/src/${CONTRACT_NAME}.cpp"