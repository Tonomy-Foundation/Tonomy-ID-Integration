#!/bin/bash

PARENT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" || exit ; pwd -P )

FILES="${PARENT_PATH}/../app.sh"
BLOCKCHAIN_FILES="$(find "${PARENT_PATH}"/../blockchain -name "*.sh")"
SCRIPT_FILES="$(find "${PARENT_PATH}"/../scripts -name "*.sh")"
FILES="${FILES} ${BLOCKCHAIN_FILES} ${SCRIPT_FILES}"

echo "Checking files:"
echo "${FILES}"

echo ""
echo "Shellchecking now..."

# shellcheck disable=SC2086
shellcheck -a -x -S style ${FILES}