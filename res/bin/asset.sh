#!/bin/bash

## Dockr by Sharan

if [ $# -gt 0 ]; then
    # Start the Asset Containers
    if [ "$1" == "up" ]; then
        shift 1

        docker-compose -f "${DOCKR_COMPOSE_ASSET}" -p "${DOCKR_ASSET_PROJECT_NAME}" up -d "$@"

    # Stop or Terminate the Asset Containers
    elif [ "$1" == "stop" ] || [ "$1" == "down" ]; then
        STOP_TYPE="$1"
        shift 1

        docker-compose -f "${DOCKR_COMPOSE_ASSET}" -p "${DOCKR_ASSET_PROJECT_NAME}" "${STOP_TYPE}" "$@"

    # Display Help for other commands
    else
        display_help "asset"
    fi

else
    display_help "asset"
fi