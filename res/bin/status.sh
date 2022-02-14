#!/bin/bash

## DockR by Sharan

PS_FORMAT="table {{.ID}}\t{{.Names}}\t{{.Label \"SERVICE\"}}\t{{title .State}}"

echo -e "${YELLOW}ASSET Containers : ${CLR}"
docker ps -f "network=${DOCKR_NETWORK}" -f "label=TYPE=asset" --format "${PS_FORMAT}" -a

echo ""
echo -e "${YELLOW}Project Containers : ${CLR}"
docker ps -f "network=${DOCKR_NETWORK}" -f "label=TYPE=project" --format "${PS_FORMAT}" -a
