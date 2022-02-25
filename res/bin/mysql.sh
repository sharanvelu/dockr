#!/bin/bash

## DockR by Sharan

# Note : "-A" flag in Some Commands
#    MySQL => Reading table information for completion of table and column names
#    MySQL => You can turn off this feature to get a quicker startup with -A

shift 1

# Check if the MySQL container is running.
is_dockr_asset_up mysql

# Source the common Database file
. ${DOCKR_COMMON_BIN_DIR}/database

DT_DATABASE_MODEL="mysql"

if [ "$1" == "import" ]; then
    DT_DATABASE_NAME=$2
    DT_DUMP_FILE=$3

    import_database

# Start SSH Bash session into MySQL container.
elif [ "$1" == "shell" ] || [ "$1" == "bash" ]; then
    start_bash_session

# Execute query statement and display the result
elif [ "$1" == "-q" ]; then
    docker-compose -f "${DOCKR_COMPOSE_ASSET}" -p "${DOCKR_ASSET_PROJECT_NAME}" exec mysql \
        bash -c "MYSQL_PWD=${DOCKR_ASSET_PASSWORD} mysql -u root -A -e \"$2\""

# Execute a SQL query within container and display the result in host machine.
elif [ "${2:--}" == "-q" ]; then

    # Check if query statement is provided.
    if [ "$3" == "" ]; then
        echo -e "${RED}Error : ${CLR}Missing query statement."
        display_help mysql_query
        exit 1
    fi

    # Execute query statement and display the result
    docker-compose -f "${DOCKR_COMPOSE_ASSET}" -p "${DOCKR_ASSET_PROJECT_NAME}" exec mysql \
        bash -c "MYSQL_PWD=${DOCKR_ASSET_PASSWORD} mysql -u root $1 -A -e \"$3\""

# Start MySQL session inside the DB.
elif [ $# == 0 ] || [ $# == 1 ]; then
    docker-compose -f "${DOCKR_COMPOSE_ASSET}" -p "${DOCKR_ASSET_PROJECT_NAME}" exec mysql \
        bash -c "MYSQL_PWD=${DOCKR_ASSET_PASSWORD} mysql -u root -A $1"

# Display common message for the unknown command
else
    shift 1

    echo -e "Unknown option ${CYAN}\"$@\"${CLR}"
    display_help mysql_query
fi
