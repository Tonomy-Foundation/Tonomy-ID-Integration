#!/usr/bin/env bash

# Ensures gracefull shutdown of nodeos process. See:
# https://github.com/EOSIO/eos/issues/4742
# https://github.com/EOSIO/eos/issues/4462#issuecomment-412772944

nodeosd_pid=$(pgrep nodeos)
echo "Found nodeos pid: [${nodeosd_pid}]"

if [ -n "$(ps -p ${nodeosd_pid} -o pid=)" ]; then
    echo "Send SIGINT"
    kill -SIGINT ${nodeosd_pid}
fi

while [ -n "$(ps -p ${nodeosd_pid} -o pid=)" ]
do
    sleep 1
done

echo "Process nodeos has finished gracefully"