#!/bin/bash

## Dockr by Sharan

# shellcheck disable=SC2089
DOCKR_IMAGE_LIST_COMMAND="docker image ls \
        -f reference=sharanvelu/laravel-php \
        -f reference=ubuntu/mysql \
        -f reference=redis \
        -f reference=postgres"

# List all images
if [ "$1" == "ls" ]; then
    ${DOCKR_IMAGE_LIST_COMMAND}

elif [ "$1" == "prune" ]; then
    dockr down all -f >> /dev/null

    if [ "$(${DOCKR_IMAGE_LIST_COMMAND} -q)" ]; then
        # shellcheck disable=SC2046
        docker image rm $(${DOCKR_IMAGE_LIST_COMMAND} -q) >> /dev/null

        echo -e "${DOCKR_NAME:-Dockr} images are ${GREEN}pruned successfully${CLR}."
    else
        echo -e "${RED}No${CLR} ${DOCKR_NAME:-Dockr} images to prune."
    fi


else
    # Display help command
    display_help image
fi
