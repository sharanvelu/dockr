#!/bin/bash

## DockR by Sharan

# Check Mandatory Environment variables
check_env() {
    # Check for Mandatory Env variables
    if [ -z "${DOCKR_PORT}" ]; then
        echo -e "Required Parameter ${YELLOW}\"DOCKR_PORT\"${CLR} is ${RED}missing${CLR} from ${CYAN}.env${CLR}"

        exit 1
    fi
    export DOCKR_PORT=${DOCKR_PORT:-80}
}

# Check for DockR Network
dockr_network_check() {
    if ! docker network ls | grep -q -w "${DOCKR_NETWORK}"
    then
        echo -e "Creating ${YELLOW}${DOCKR_NAME}${CLR} Network."
        docker network create "${DOCKR_NETWORK}" >> /dev/null
        echo -e "${GREEN}${DOCKR_NAME} Network Created.${CLR}"
        echo -e ""
    fi
}

# Check for DockR Network
dockr_composer_cache_volume_check() {
    if ! docker volume ls | grep -q -w "${DOCKR_COMPOSER_CACHE_VOLUME}"
    then
        echo -e "Creating ${YELLOW}${DOCKR_NAME} Composer Cache${CLR} Volume"
        docker volume create "${DOCKR_COMPOSER_CACHE_VOLUME}" >> /dev/null
        echo -e "${GREEN}${DOCKR_NAME} Composer Cache Volume Created.${CLR}"
        echo -e ""
    fi
}

# Manage Asset Containers (Mysql, Redis, ...)
asset_container_check() {
    if [ -n "${DOCKR_SKIP_ASSET}" ]; then
        echo -e "${YELLOW}DOCKR_SKIP_ASSET${CLR} is provided. Skipping Asset containers and DB check.\n"
    else
        # Check if Docker asset containers are up (To avoid "not found" result in CLI)
#        if ! docker-compose ls | grep "${DOCKR_ASSET_PROJECT_NAME}" >> /dev/null
#        then
#            DOCKR_ASSET_MYSQL_STARTED=1
#            DOCKR_ASSET_POSTGRES_STARTED=1
#            SHOULD_START_ASSET_CONTAINER=1
#        else
            if ! docker-compose -f "${DOCKR_COMPOSE_ASSET}" -p "${DOCKR_ASSET_PROJECT_NAME}" ps | grep mysql | grep -q running
            then
                DOCKR_ASSET_MYSQL_STARTED=1
                SHOULD_START_ASSET_CONTAINER=1
            fi

            if ! docker-compose -f "${DOCKR_COMPOSE_ASSET}" -p "${DOCKR_ASSET_PROJECT_NAME}" ps | grep postgres | grep -q running
            then
                DOCKR_ASSET_POSTGRES_STARTED=1
                SHOULD_START_ASSET_CONTAINER=1
            fi

            if ! docker-compose -f "${DOCKR_COMPOSE_ASSET}" -p "${DOCKR_ASSET_PROJECT_NAME}" ps | grep redis | grep -q running
            then
                SHOULD_START_ASSET_CONTAINER=1
            fi
#        fi

        if [ -n "${SHOULD_START_ASSET_CONTAINER}" ]; then
            echo -e "Starting asset containers..."
            docker-compose -f "${DOCKR_COMPOSE_ASSET}" -p "${DOCKR_ASSET_PROJECT_NAME}" up -d
            echo -e "Asset containers ${GREEN}started${CLR}."
            echo -e ""
        fi
    fi
}

# Check for database existence mentioned in "DB_DATABASE" env
check_project_database() {
    if [ -n "${DOCKR_SKIP_ASSET}" ] || [ -n "${DOCKR_SKIP_DB_CHECK}" ]; then
        if [ -n "${DOCKR_SKIP_DB_CHECK}" ] && [ -z "${DOCKR_SKIP_ASSET}" ]; then
            echo -e "${YELLOW}DOCKR_SKIP_DB_CHECK${CLR} is provided. Skipping DB check.\n"
        fi
    else
        if [ "$DB_CONNECTION" == "mysql" ]; then
            echo -e "Checking for database ${CYAN}${DB_DATABASE}${CLR} presence in Mysql."
            # When the container starts now, Sleep for 3 seconds before making a call
            # This is to prevent error from mysql server.
            if [ -n "${DOCKR_ASSET_MYSQL_STARTED}" ]; then
                sleep 3
            fi

            # Create DB with specified name is not present.
            if ! docker-compose -f "${DOCKR_COMPOSE_ASSET}" -p "${DOCKR_ASSET_PROJECT_NAME}" exec mysql bash -c "MYSQL_PWD=${DOCKR_ASSET_PASSWORD} mysql -u root -e \"show databases;\" | grep -q -w ${DB_DATABASE}"
            then
                echo -e "Creating Database ${CYAN}${DB_DATABASE}${CLR}."
                docker-compose -f "${DOCKR_COMPOSE_ASSET}" -p "${DOCKR_ASSET_PROJECT_NAME}" exec mysql bash -c "MYSQL_PWD=${DOCKR_ASSET_PASSWORD} mysql -u root -e \"create database ${DB_DATABASE}\" >> /dev/null"
                docker-compose -f "${DOCKR_COMPOSE_ASSET}" -p "${DOCKR_ASSET_PROJECT_NAME}" exec mysql bash -c "MYSQL_PWD=${DOCKR_ASSET_PASSWORD} mysql -u root -e \"GRANT ALL PRIVILEGES ON *.* TO '${DOCKR_ASSET_USERNAME}'@'%'\" >> /dev/null"
                echo -e "Database ${YELLOW}${DB_DATABASE}${CLR} created successfully."
            else
                echo -e "Database ${YELLOW}${DB_DATABASE}${CLR} already exists. Skipping..."
            fi

            echo -e ""

        elif [ "$DB_CONNECTION" == "pgsql" ] || [ "$DB_CONNECTION" == "postgres" ]; then
            echo -e "Checking for database ${CYAN}${DB_DATABASE}${CLR} presence in Postgres."
            if [ -n "${DOCKR_ASSET_POSTGRES_STARTED}" ]; then
                sleep 3
            fi

            # Create DB with specified name is not present.
            if ! docker-compose -f "${DOCKR_COMPOSE_ASSET}" -p "${DOCKR_ASSET_PROJECT_NAME}" exec postgres bash -c "psql -U ${DOCKR_ASSET_USERNAME} -l | grep -q -w ${DB_DATABASE}"
            then
                echo -e "Creating Database ${CYAN}${DB_DATABASE}${CLR}."
                docker-compose -f "${DOCKR_COMPOSE_ASSET}" -p "${DOCKR_ASSET_PROJECT_NAME}" exec postgres bash -c "psql -U ${DOCKR_ASSET_USERNAME} -d ${DOCKR_ASSET_DEFAULT_DATABASE} -c \"create database ${DB_DATABASE}\" >> /dev/null"
                echo -e "Database ${YELLOW}${DB_DATABASE}${CLR} created successfully."
            else
                echo -e "Database ${YELLOW}${DB_DATABASE}${CLR} already exists. Skipping..."
            fi

            echo -e ""
        fi
    fi
}

set -e

check_env

dockr_network_check

dockr_composer_cache_volume_check

asset_container_check

check_project_database

if [ -n "${DOCKR_WORKER}" ]; then
    WORKER_SERVICE="worker"
fi

docker-compose -f "${DOCKER_COMPOSE_FILE}" -p "${PROJECT_NAME}" up -d web ${WORKER_SERVICE}

if [ -n "${DOCKR_PORT}" ]; then
    echo -e "\nYour Application should be running at ${RED}${UNDERLINE}http://dockr:${DOCKR_PORT}${CLR}"
fi
