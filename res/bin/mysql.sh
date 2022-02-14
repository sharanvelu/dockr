#!/bin/bash

## DockR by Sharan

# Note : "-A" flag in Some Commands
# MySQL => Reading table information for completion of table and column names
# MySQL => You can turn off this feature to get a quicker startup with -A

shift 1

# Check if the MySQL container is running.
is_dockr_asset_up mysql

# Import DB dump into specified Database..
if [ "$1" == "import" ]; then
    # Check if the required parameters are provided.
    if [ $# -lt 3 ]; then
        echo -e "${RED}Error :${CLR} MySQL Import statement requires two arguments : ${YELLOW}DB_NAME${CLR} and ${YELLOW}SQL_DUMP_FILE${CLR}"
        display_help mysql_import
        exit 1
    fi

    # Check if the provided sql_file_path contains any blank spaces to avoid error.
    if echo "$3" | grep -q "\ "; then
        echo -e "${RED}Error :${CLR} Avoid blank spaces (\" \") in the file_path."
        echo -e "Provided File Path : ${YELLOW}$3${CLR}"
        exit 1
    fi

    # Trim the host machine file_path to file_name to avoid "directory not found" issue inside the container.
    DOCKR_CONTAINER_DUMP_FILE_PATH="/opt/$(echo $3 | sed 's/.*\///')"

    # Copy the Dump file into container
    docker cp "$3" $(docker-compose -f "${DOCKR_COMPOSE_ASSET}" -p "${DOCKR_ASSET_PROJECT_NAME}" ps -q mysql):${DOCKR_CONTAINER_DUMP_FILE_PATH}
    # Import the Dump file using Mysql Import Command
    docker-compose -f "${DOCKR_COMPOSE_ASSET}" -p "${DOCKR_ASSET_PROJECT_NAME}" exec mysql \
        bash -c "MYSQL_PWD=${DOCKR_ASSET_PASSWORD} mysql -u root $2 < ${DOCKR_CONTAINER_DUMP_FILE_PATH}"
    # Delete the Dump file from the container
    docker-compose -f "${DOCKR_COMPOSE_ASSET}" -p "${DOCKR_ASSET_PROJECT_NAME}" exec mysql \
        bash -c "rm -rf ${DOCKR_CONTAINER_DUMP_FILE_PATH}"

# Start SSH Bash session into MySQL container.
elif [ "$1" == "shell" ] || [ "$1" == "bash" ]; then
    docker-compose -f "${DOCKR_COMPOSE_ASSET}" -p "${DOCKR_ASSET_PROJECT_NAME}" exec mysql bash

# Execute a SQL query within container and display the result in host machine.
elif [ "${2:-q}" == "-q" ]; then

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

    echo -e "Unknown option ${YELLOW}\"$@\"${CLR}"
    display_help mysql_query
fi
