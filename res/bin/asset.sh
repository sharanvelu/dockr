#!/bin/bash

## DockR by Sharan

. "${DOCKR_COMMON_BIN_DIR}/asset"

# Start the Asset Containers
if [ "$2" == "up" ]; then
    start_asset_containers

# Stop or Terminate the Asset Containers
elif [ "$2" == "stop" ] || [ "$2" == "down" ]; then
    docker-compose -f "${DOCKR_COMPOSE_ASSET}" -p "${DOCKR_ASSET_PROJECT_NAME}" "$2"

# Display Help for other commands
else
    display_help "asset"
fi
