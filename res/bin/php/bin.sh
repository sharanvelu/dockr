#!/bin/bash

## DockR by Sharan

shift 1

# Check if DockR is running
is_dockr_up

# Execute "./vendor/bin" (Binary) Command within web container.
docker-compose -f "${DOCKER_COMPOSE_FILE}" -p "${PROJECT_NAME}" exec web \
            vendor/bin/$*