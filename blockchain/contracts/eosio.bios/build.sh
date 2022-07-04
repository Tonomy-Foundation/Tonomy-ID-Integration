#!/bin/bash

PARENT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" || exit ; pwd -P )

DOCKER_WORKING_DIR="/contract"
CONTRACT_NAME="eosio.bios"
docker run -v "${PARENT_PATH}:${DOCKER_WORKING_DIR}"\
    eostudio/eosio.cdt:v1.8.1\
    eosio-cpp\
    -abigen\
    -I "${DOCKER_WORKING_DIR}"/include\
    -R resource\
    -contract "${CONTRACT_NAME}"\
    -o "${DOCKER_WORKING_DIR}/${CONTRACT_NAME}.wasm"\
    "${DOCKER_WORKING_DIR}/src/${CONTRACT_NAME}.cpp"