#!/bin/bash

## DockR by Sharan

# Import Common logics for Config
. "${DOCKR_COMMON_BIN_DIR}/config"

# Checks For DockR Running...
is_dockr_up() {
    if ${DOCKER_COMPOSE_COMMAND} -f "${DOCKR_COMPOSE_FILE}" -p "${PROJECT_NAME}" ps | grep -q web; then
        # Check if there is exited web containers
        EXITED_STATE="$(${DOCKER_COMPOSE_COMMAND} -f "${DOCKR_COMPOSE_FILE}" -p "${PROJECT_NAME}" ps | grep web | grep exited)"
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
    if ${DOCKER_COMPOSE_COMMAND} -f "${DOCKR_COMPOSE_ASSET}" -p "${DOCKR_ASSET_PROJECT_NAME}" ps | grep -q -w "${DT_ASSET}"; then
        # Check if there is exited mysql containers
        if ${DOCKER_COMPOSE_COMMAND} -f "${DOCKR_COMPOSE_ASSET}" -p "${DOCKR_ASSET_PROJECT_NAME}" ps | grep -w "${DT_ASSET}" | grep -q -w exited; then
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

        # Start Context
        start_docker_context
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

# Check for DockR Volumes for Asset Containers Data
check_dockr_volumes() {
    check_and_create_volume dockr_asset_mysql
    check_and_create_volume dockr_asset_postgres
    check_and_create_volume dockr_asset_redis
    check_and_create_volume dockr_asset_opensearch
}

# Check and create volumes if not exists
check_and_create_volume() {
    if ! docker volume ls | grep -q -w $1; then
        echo -e "${PROCESS}Creating ${CYAN}$1${CLR} Volume."
        docker volume create $1 >>/dev/null
        echo -e "${GREEN}$1 Volume Created.${CLR}"
        echo -e ""
    fi
}

start_docker_context() {
    # Check for the context from config
    # Default will be docker
    DT_CONTEXT=`get_config context`

    if [ ${DT_CONTEXT} == "docker" ]; then
        echo -e "\n${PROCESS}Starting Docker. It might take some time to start. Please try after few minutes.${CLR}"

        open --background -a Docker
        if [ $? == 1 ]; then
            echo -e "\n${PROCESS}Context set to ${CYAN}Docker${CLR}. But Docker Desktop is not found. Try switching to different context.${CLR}"
        fi

        exit 1
    elif [ ${DT_CONTEXT} == "colima" ]; then
        echo -e "\n${PROCESS}Starting Colima. Please wait.${CLR}\n"
        colima start
        echo -e "\n"

        is_docker_up
    else
        echo -e "\n${PROCESS}Unknown docker context in config. Please try again...${CLR}"
        exit 1
    fi
}
