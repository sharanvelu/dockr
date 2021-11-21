#!/bin/bash

## Dockr by Sharan

if [ "$1" == "all" ]; then
    shift 1

    PS_RESULTS=$(docker ps -f "network=${DOCKR_NETWORK}" -q -a)
    # shellcheck disable=SC2086
    if [ -n "${PS_RESULTS}" ]; then
        echo -e "${RED}Stopping${CLR} all containers."

        # Force remove containers.
        if echo "$@" | grep -q -w "\-f"; then
            docker rm -f ${PS_RESULTS} >> /dev/null

        # Handles Normal Stop procedure.
        else
            # Stops the container before removing..
            docker stop ${PS_RESULTS} >> /dev/null
            # Remove the container if it was down command.
            if [ "${STOP_TYPE}" == "down" ]; then
                docker rm ${PS_RESULTS} >> /dev/null
            fi
        fi

        echo -e "All containers ${GREEN}stopped${CLR} successfully."
    else
        echo -e "${RED}No${CLR} ${DOCKR_NAME} containers are running."
    fi

    exit 0
fi

if [ "$1" == "asset" ]; then
    shift 1

    TERMINATE_ASSET_CONTAINER=1
fi

docker-compose -f "${DOCKER_COMPOSE_FILE}" -p "${PROJECT_NAME}" "${STOP_TYPE}" "$@"

if [ -n "${TERMINATE_ASSET_CONTAINER}" ]; then
    echo -e ""
    echo -e "Stopping asset containers..."
    docker-compose -f "${DOCKR_COMPOSE_ASSET}" -p "${DOCKR_ASSET_PROJECT_NAME}" "${STOP_TYPE}"
    echo -e "Asset containers ${GREEN}stopped${CLR} successfully."
fi