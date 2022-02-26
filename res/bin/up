#!/bin/bash

## DockR by Sharan

# Source the Common Asset script
. "${DOCKR_COMMON_BIN_DIR}/asset"

# Source the common Database script
. "${DOCKR_COMMON_BIN_DIR}/database"

# Check Mandatory Environment variables
check_required_project_env() {
    # Check for Mandatory Env variables
    if [ -z "${DOCKR_PORT}" ]; then
        echo -e "Required Parameter ${CYAN}\"DOCKR_PORT\"${CLR} is ${RED}missing${CLR} from ${CYAN}.env${CLR}"

        exit 1
    fi
    export DOCKR_PORT=${DOCKR_PORT:-80}
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

# Check for DockR Network
check_dockr_composer_cache_volume() {
    if ! docker volume ls | grep -q -w "${DOCKR_COMPOSER_CACHE_VOLUME}"; then
        echo -e "Creating ${CYAN}${DOCKR_NAME} Composer Cache${CLR} Volume"
        docker volume create "${DOCKR_COMPOSER_CACHE_VOLUME}" >>/dev/null
        echo -e "${GREEN}${DOCKR_NAME} Composer Cache Volume Created.${CLR}"
        echo -e ""
    fi
}

# Manage Asset Containers (Mysql, Postgres, Redis, ...)
check_asset_container() {
    if [ -n "${DOCKR_SKIP_ASSET}" ]; then
        echo -e "${CYAN}DOCKR_SKIP_ASSET${CLR} is provided. Skipping Asset containers and DB check.\n"
        if [ -n "${DOCKR_OVERRIDE_ASSET_CONFIG}" ]; then
            echo -e "${RED}Warning :${CLR} Both ${CYAN}'DOCKR_SKIP_ASSET'${CLR} and ${CYAN}'DOCKR_OVERRIDE_ASSET_CONFIG'${CLR} are given."
            echo -e "${CYAN}'DOCKR_OVERRIDE_ASSET_CONFIG'${CLR} will not be taken into consideration.\n"
        fi
    else
        start_asset_containers
    fi
}

# Check for database existence mentioned in "DB_DATABASE" env
check_project_database_existence() {
    if [ -n "${DOCKR_SKIP_ASSET}" ] || [ -n "${DOCKR_SKIP_DB_CHECK}" ]; then
        if [ -z "${DOCKR_SKIP_ASSET}" ] && [ -n "${DOCKR_SKIP_DB_CHECK}" ]; then
            echo -e "${CYAN}DOCKR_SKIP_DB_CHECK${CLR} is provided. Skipping DB check.\n"
        fi
    else
        create_project_database
    fi
}

set +e

check_required_project_env

check_dockr_network

check_dockr_composer_cache_volume

check_asset_container

check_project_database_existence

if [ -n "${DOCKR_WORKER}" ]; then
    WORKER_SERVICE="worker"
fi

docker-compose -f "${DOCKER_COMPOSE_FILE}" -p "${PROJECT_NAME}" up -d web ${WORKER_SERVICE}

if [ -n "${DOCKR_PORT}" ]; then
    echo -e "\nYour Application should be running at ${RED}${UNDERLINE}http://dockr:${DOCKR_PORT}${CLR}"
fi
