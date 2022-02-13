#!/bin/bash

## Dockr by Sharan

shift 1

# Check if DockR is running
is_dockr_up

# Generate Seeder command.
SEEDER_COMMAND="db:seed"
if [ $# -gt 0 ]; then
    SEEDER_COMMAND="${SEEDER_COMMAND} --class=$1"
fi

# Run db:seed command within the container
docker-compose -f "${DOCKER_COMPOSE_FILE}" -p "${PROJECT_NAME}" exec web \
    php artisan ${SEEDER_COMMAND}