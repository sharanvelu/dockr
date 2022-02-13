#!/bin/bash

## Dockr by Sharan

# Note : art is a shorthand property for artisan command

shift 1

# Check if DockR is running
is_dockr_up

# Execute Artisan command within the container.
docker-compose -f "${DOCKER_COMPOSE_FILE}" -p "${PROJECT_NAME}" exec web \
    php artisan $@
