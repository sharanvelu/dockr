#!/bin/bash

## DockR by Sharan

shift 1

# Check if DockR is running
is_dockr_up

# Display Dockr Name
display_dockr_name

# Display Port information.
echo -e "Published Port : ${CYAN}${DOCKR_PORT:--}${CLR}"
echo -e "Published At : ${RED}${UNDERLINE}http://dockr:${DOCKR_PORT}${CLR}"
