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
    echo -e "${CYAN}Asset Images : ${CLR}"
    ${DOCKR_IMAGE_LIST_ASSET}

    echo ""
    echo -e "${CYAN}Project Images : ${CLR}"
    ${DOCKR_IMAGE_LIST_PROJECT}

# Prune all downloaded images.
elif [ "$2" == "prune" ]; then
    echo -e "${RED}Warning :${CLR} This will remove all the downloaded images. This action cannot be undone.\n"
    read -p "Are you sure? [y/n] : " -n 1 -r
    echo -e "\n"
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${PROCESS}Destroying running containers..."
        dockr down all -f >>/dev/null

        # Check if images exists for removing.
        if [ "$(${DOCKR_IMAGE_LIST_ALL} -q)" ]; then
            echo -e "${PROCESS}Deleting Images...\n"
            docker image rm $(${DOCKR_IMAGE_LIST_ALL} -q) >>/dev/null

            echo -e "All ${DOCKR_NAME} images are ${GREEN}pruned successfully${CLR}."
        else
            echo -e "${RED}No${CLR} ${DOCKR_NAME} images to prune."
        fi
    fi

else
    # Display help command
    display_help image
fi
