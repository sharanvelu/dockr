#!/bin/bash

## DockR by Sharan

DOCKR_IMAGE_LIST_ALL="docker image ls \
        -f reference=sharanvelu/laravel-php \
        -f reference=ubuntu/mysql \
        -f reference=redis \
        -f reference=postgres"

DOCKR_IMAGE_LIST_ASSET="docker image ls \
       -f reference=ubuntu/mysql \
       -f reference=redis \
       -f reference=postgres"

DOCKR_IMAGE_LIST_PROJECT="docker image ls \
       -f reference=sharanvelu/laravel-php"

# List all images
if [ "$2" == "ls" ]; then
    echo -e "${YELLOW}ASSET Images : ${CLR}"
    ${DOCKR_IMAGE_LIST_ASSET}

    echo ""
    echo -e "${YELLOW}Project Images : ${CLR}"
    ${DOCKR_IMAGE_LIST_PROJECT}

elif [ "$2" == "prune" ]; then
    dockr down all -f >> /dev/null

    if [ "$(${DOCKR_IMAGE_LIST_ALL} -q)" ]; then
        docker image rm $(${DOCKR_IMAGE_LIST_ALL} -q) >> /dev/null

        echo -e "All ${DOCKR_NAME} images are ${GREEN}pruned successfully${CLR}."
    else
        echo -e "${RED}No${CLR} ${DOCKR_NAME} images to prune."
    fi

else
    # Display help command
    display_help image
fi
