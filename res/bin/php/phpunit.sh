#!/bin/bash

## Dockr by Sharan

shift 1

# Check if DockR is running
is_dockr_up

# Execute PHP unit commands within the command.
docker-compose -f "${DOCKER_COMPOSE_FILE}" -p "${PROJECT_NAME}" exec web \
    ./vendor/bin/phpunit $@
