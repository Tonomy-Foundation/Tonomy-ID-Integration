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

Then run all the commands found in the functions `server.sh`

```bash
server_setup_prerequisits
server_setup_tonomy_first_time
server_setup_ssl
```

Next time, to reset and re-initalize

```bash
server_reset
```
