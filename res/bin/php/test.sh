#!/bin/bash

## Dockr by Sharan

shift 1

# Check if DockR is running
is_dockr_up

# Run php artisan test commands inside the container.
docker-compose -f "${DOCKER_COMPOSE_FILE}" -p "${PROJECT_NAME}" exec web \
    php artisan test $@