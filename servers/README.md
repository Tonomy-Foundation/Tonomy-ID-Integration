# Tonomy Servers

## SSH to server

```bash
# replace development with master | testnet | development
source ./server.sh development
ssh_to_server
```

## Setup server

```bash
# replace development with master | testnet | development
source ./server.sh development
local_copy_files_to_server
ssh_to_server
```

You will need to set the environment variables:

- `TONOMY_OPS_PRIVATE_KEY`: the private key of the operations account that will be used for the tonomy@active account. This should be provided to the CI and Devops for the [Tonomy Communication](https://github.com/Tonomy-Foundation/Tonomy-Communication) and to the CI for [Tonomy Contracts](https://github.com/Tonomy-Foundation/Tonomy-Contracts) to deploy the `tonomy` account (NOT FOR MAINNET THOUGH!)
- `TONOMY_BOARD_PUBLIC_KEYS`: the public keys (in JSON array format) of the network governance multi-signature account that controls governance operations. This should be added to the CI for [Tonomy Contracts](https://github.com/Tonomy-Foundation/Tonomy-Contracts) to deploy the `tonomy` account (NOT FOR MAINNET THOUGH!)
- `TONOMY_TEST_ACCOUNTS_PASSPHRASE`: the passphrase that will be used for the App store test user and demo app users. This needs to be provided to Google/Apple play store instructions for testing the [Tonomy ID](https://github.com/Tonomy-Foundation/Tonomy-ID) app

The corresponding keys/passphrases will also need to be added to relevant CI/Devops processes for your environment:

Then run all the commands found in the functions found here `server.sh`

```bash
server_setup_prerequisits
server_setup_tonomy_first_time
server_setup_ssl
```

Next time, to reset and re-initialize

```bash
git pull
cd servers
source ./server.sh development
cd ../

# Run the environment specific settings. Example (developer environment)
export NODE_ENV=staging
export TONOMY_OPS_PRIVATE_KEY=PVT_K1_24kG9VcMk3VkkgY4hh42X262AWV18YcPjBTd2Hox4YWoP8vRTU
export TONOMY_BOARD_PUBLIC_KEYS='{"keys":["PUB_K1_81aU18Y3RdyFf2WY4Wy7g7fvG9M9d7hmY4rhNFeXouYYPjExua","PUB_K1_5HWprCobEy8LiYUpfVmh8BdGDb8ANPc8rhBhtNqhvXnuxpyCaq","PUB_K1_5VLYVhqfe7oh8TW2i6Nw251wbpoZ4p15DV7udqDjiaKnryx9YU"]}'
export TONOMY_TEST_ACCOUNTS_PASSPHRASE='above day fever lemon piano sport'
history -d -2
history -d -2
history -d -2

server_reset
```
