#!/bin/bash

## DockR by Sharan

shift 1

# Check if DockR Asset Containers are running.
is_dockr_asset_up redis

# Initiate a Redis session within the Redis container.
docker-compose -f "${DOCKR_COMPOSE_ASSET}" -p "${DOCKR_ASSET_PROJECT_NAME}" exec redis \
    redis-cli
