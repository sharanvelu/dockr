#!/bin/bash

## DockR by Sharan

shift 1

# Check if DockR Asset Containers are running.
is_dockr_asset_up postgres

# Source the common Database file
. ${DOCKR_COMMON_BIN_DIR}/database

DT_DATABASE_MODEL="postgres"

if [ "$1" == "import" ]; then
    DT_DATABASE_NAME=$2
    DT_DUMP_FILE=$3

    import_database

# Start SSH Bash session into Postgres container.
elif [ "$1" == "shell" ] || [ "$1" == "bash" ]; then
    start_bash_session

# Execute query statement and display the result
elif [ "$1" == "-q" ]; then
    docker-compose -f "${DOCKR_COMPOSE_ASSET}" -p "${DOCKR_ASSET_PROJECT_NAME}" exec postgres \
        bash -c "psql -U ${DOCKR_ASSET_USERNAME} -c \"$2\""

# Execute a SQL query within container and display the result in host machine.
elif [ "${2:--}" == "-q" ]; then

    # Check if query statement is provided.
    if [ "$3" == "" ]; then
        echo -e "${RED}Error : ${CLR}Missing query statement."
        display_help postgres_query
        exit 1
    fi

    # Execute query statement and display the result
    docker-compose -f "${DOCKR_COMPOSE_ASSET}" -p "${DOCKR_ASSET_PROJECT_NAME}" exec postgres \
        bash -c "psql -U ${DOCKR_ASSET_USERNAME} -d $1 -c \"$3\""

# Start MySQL session inside the DB.
elif [ $# == 0 ] || [ $# == 1 ]; then
    # Start a postgres session in postgres container.
    docker-compose -f "${DOCKR_COMPOSE_ASSET}" -p "${DOCKR_ASSET_PROJECT_NAME}" exec postgres \
        bash -c "psql -U ${DOCKR_ASSET_USERNAME} ${1:-dockr}"

# Display common message for the unknown command
else
    shift 1

    echo -e "Unknown option ${CYAN}\"$@\"${CLR}"
    display_help mysql_query
fi
