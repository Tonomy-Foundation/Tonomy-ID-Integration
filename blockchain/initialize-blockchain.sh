#!/bin/bash

set -u ## exit if you try to use an uninitialised variable
set -e ## exit if any statement fails

# Make sure working dir is same as this dir, so that script can be excuted from another working directory
PARENT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$PARENT_PATH"

# Create a new wallet with the eosio and other keys
cleos wallet create --file /data/wallet.txt

# import eosio
PKEY_EOSIO="PVT_K1_2bfGi9rYsXQSXXTvJbDAPhHLQUojjaNLomdm3cEJ1XTzMqUt3V"
cleos wallet import --private-key $PKEY_EOSIO

# Enable protocol feature pre-activation PREACTIVATE_FEATURE for eosio.contract v1.8+
curl -X POST http://127.0.0.1:8888/v1/producer/schedule_protocol_feature_activations -d '{"protocol_features_to_activate": ["0ec7e080177b2c02b278d5088611686b49d739925a92d9bfcacd7fc6b74053bd"]}'
sleep 1

# Load the eosio.boot contract so with activate action
# https://eosio.stackexchange.com/questions/5235/error-while-deploying-eosio-system-contract-to-eosio-account-while-setting-up-a
cleos set contract eosio /var/repo/Tonomy-Contracts/contracts/eosio.boot eosio.boot.wasm eosio.boot.abi -p eosio@active
sleep .1

./initialize-features.sh
sleep 1

cleos set contract eosio /var/repo/Tonomy-Contracts/contracts/eosio.bios eosio.bios.wasm eosio.bios.abi -p eosio@active
sleep 1