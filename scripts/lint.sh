#!/bin/bash

# Make sure working dir is same as this dir, so that script can be excuted from another working directory
PARENT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" || exit ; pwd -P )

docker run -v "${PARENT_PATH}/..:/var/repo" koalaman/shellcheck -a -x -S style /var/repo/app.sh

# TODO go through ../blockchain dir and lint all filse $(find /var/repo/blockchain -name "*.sh")
# TODO go through all of ../scrift dir and lint all files