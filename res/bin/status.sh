#!/bin/bash

## DockR by Sharan

PS_FORMAT="table {{.ID}}\t{{.Names}}\t{{.Label \"SERVICE\"}}\t{{.Ports}}\t{{title .State}}\t{{.Status}}"

echo -e "${CYAN}Asset Containers : ${CLR}"
docker ps -f "network=${DOCKR_NETWORK}" -f "label=TYPE=asset" --format "${PS_FORMAT}" -a

echo ""
echo -e "${CYAN}Project Containers : ${CLR}"
docker ps -f "network=${DOCKR_NETWORK}" -f "label=TYPE=project" --format "${PS_FORMAT}" -a
