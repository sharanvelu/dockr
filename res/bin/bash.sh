#!/bin/bash

## DockR by Sharan

is_dockr_up

docker-compose -f "${DOCKER_COMPOSE_FILE}" -p "${PROJECT_NAME}" exec web \
    bash
