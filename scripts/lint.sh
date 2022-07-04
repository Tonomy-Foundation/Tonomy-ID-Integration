#!/bin/bash

# Make sure working dir is same as this dir, so that script can be excuted from another working directory
PARENT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" || exit ; pwd -P )

docker run -v "${PARENT_PATH}/..:/var/repo" pipelinecomponents/shellcheck /var/repo/scripts/lint-in-container.sh