#!/bin/bash

## Dockr by Sharan

shift 1

# Check if DockR Asset Containers are running.
is_dockr_asset_up postgres

# Start a postgres session in postgres container.
docker-compose -f "${DOCKR_COMPOSE_ASSET}" -p "${DOCKR_ASSET_PROJECT_NAME}" exec postgres \
    psql -U "${DOCKR_ASSET_USERNAME}" "${1:-dockr}"
