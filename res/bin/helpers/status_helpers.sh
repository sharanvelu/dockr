#!/bin/bash

## DockR by Sharan

# Checks For DockR Running...
is_dockr_up() {
    if docker-compose -f "${DOCKR_COMPOSE_FILE}" -p "${PROJECT_NAME}" ps | grep -q web; then
        # Check if there is exited web containers
        EXITED_STATE="$(docker-compose -f "${DOCKR_COMPOSE_FILE}" -p "${PROJECT_NAME}" ps | grep web | grep exited)"
        if [ -n "${EXITED_STATE}" ]; then
            dockr_container_is_stopped
        fi

    # There is no container. Terminate the execution.
    else
        dockr_is_down
    fi
}

# Checks For DockR Asset Containers running...
is_dockr_asset_up() {
    DT_ASSET="dockr_$1"
    if docker-compose -f "${DOCKR_COMPOSE_ASSET}" -p "${DOCKR_ASSET_PROJECT_NAME}" ps | grep -q -w "${DT_ASSET}"; then
        # Check if there is exited mysql containers
        if docker-compose -f "${DOCKR_COMPOSE_ASSET}" -p "${DOCKR_ASSET_PROJECT_NAME}" ps | grep -w "${DT_ASSET}" | grep -q -w exited; then
            dockr_asset_container_is_stopped "$1"
        fi

    # There is no asset container. Terminate the execution.
    else
        dockr_asset_container_not_running "$1"
    fi
}

is_docker_up() {
    # Checks For the working of Docker Engine...
    if ! docker info >> /dev/null 2>&1; then
        echo -e "${BOLD}Docker is not running.${CLR}"

        exit 1
    fi
}

# Check for DockR Network
check_dockr_network() {
    if ! docker network ls | grep -q -w "${DOCKR_NETWORK}"; then
        echo -e "Creating ${CYAN}${DOCKR_NAME}${CLR} Network."
        docker network create "${DOCKR_NETWORK}" >>/dev/null
        echo -e "${GREEN}${DOCKR_NAME} Network Created.${CLR}"
        echo -e ""
    fi
}
