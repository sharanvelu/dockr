#!/bin/bash

## DockR by Sharan

shift 1

# Check if DockR is running
is_dockr_up

# Display Port information.
display_dockr_name
echo -e "Published Port : ${YELLOW}${DOCKR_PORT:--}${CLR}"
echo -e "Published At : ${RED}${UNDERLINE}http://dockr:${DOCKR_PORT}${CLR}"
