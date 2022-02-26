#!/bin/bash

## DockR by Sharan

STOP_TYPE=$1

# Include common scripts for down and stop command
. "${DOCKR_COMMON_BIN_DIR}/down_stop"

if [ "$2" == "all" ]; then
    terminate_all $@
fi

docker-compose -f "${DOCKER_COMPOSE_FILE}" -p "${PROJECT_NAME}" "${STOP_TYPE}"

if [ "$2" == "asset" ]; then
    terminate_asset "${STOP_TYPE}"
fi
