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
