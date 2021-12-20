#!/bin/bash

## Dockr by Sharan

# Include common scripts for down and stop command
. "${DOCKR_COMMON_BIN_DIR}/config"

if [ $2 == 'set' ]; then
    set_config $3 $4
fi

if [ $2 == 'get' ]; then
    get_config $3
fi
