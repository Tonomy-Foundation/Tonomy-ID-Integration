#!/bin/bash

function help {
    echo ""
    echo "Usage:"
    echo "    app.sh [commands]"
    echo ""
    echo "Commands:"
    echo "    install - installs all application repositories"
    echo "    init    - starts application components through docker compose and initializes and resets the blockchain and database"
    echo "    start   - starts application components through docker compose"
    echo "    stop    - stops application execution"
    echo "    reset   - stops application execution and resets all data"
}