#!/bin/bash

ARG1=$1
ARG2=$2

set -u ## exit if you try to use an uninitialised variable
set -e ## exit if any statement fails

# Make sure working dir is same as this dir, so that script can be excuted from another working directory
PARENT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

# import functions
source ./scripts/helpers.sh
source ./scripts/print.sh

if [ -z "$ARG1" ]
then
    help
elif [ "$ARG1" == "gitinit" ]
then
    gitinit
elif [ "$ARG1" == "install" ]
then
    install "${ARG2}"
    buildcontracts
elif [ "$ARG1" == "init" ]
then
    stop
    reset
    buildcontracts
    startdocker
    init
elif [ "$ARG1" == "start" ]
then
    stop
    start "${ARG2}"
elif [ "$ARG1" == "stop" ]
then
    stop
elif [ "$ARG1" == "reset" ]
then
    stop
    reset "${ARG2}"
elif [ "$ARG1" == "test" ]
then
    stop
    reset
    buildcontracts
    startdocker
    init
    test "${ARG2}"
elif [ "$ARG1" == "log" ]
then
    log "${ARG2}"
else
    help
fi
