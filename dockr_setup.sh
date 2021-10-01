#!/usr/bin/env bash

## Dockr By SHARAN

CLR='\033[0m'

BLACK='\033[1;30m'
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'

BLACK_BG='\033[1;40m'
RED_BG='\033[1;41m'
GREEN_BG='\033[1;42m'
YELLOW_BG='\033[1;43m'
BLUE_BG='\033[1;44m'
MAGENTA_BG='\033[1;45m'
CYAN_BG='\033[1;46m'
WHITE_BG='\033[1;47m'

function get_php_version {
    echo -e "Please select your PHP version"

    echo -e ""
    echo -e "1) PHP 5.6"
    echo -e "2) PHP 7.0"
    echo -e "3) PHP 7.1"
    echo -e "4) PHP 7.2"
    echo -e "5) PHP 7.3"
    echo -e "6) PHP 7.4"
    echo -e "7) PHP 8.0"
    echo -e "8) Quit"

    read -p "Your PHP Version ? : " opt

    case $opt in
        "1")
            CONTAINER_IMAGE="phpdockerio/php56-fpm";;
        "2")
            CONTAINER_IMAGE="phpdockerio/php7-fpm";;
        "3")
            CONTAINER_IMAGE="phpdockerio/php71-fpm";;
        "4")
            CONTAINER_IMAGE="phpdockerio/php72-fpm";;
        "5")
            CONTAINER_IMAGE="phpdockerio/php73-fpm";;
        "6")
            CONTAINER_IMAGE="phpdockerio/php74-fpm";;
        "7")
            CONTAINER_IMAGE="phpdockerio/php80-fpm";;
        "8")
            exit 0;;
        *)
            echo "invalid option $REPLY";;
    esac
}

function get_docker_compose_file_name {
    echo -e "Please select your Docker Compose File Name"

    echo -e ""
    echo -e "1) docker-compose.yml"
    echo -e "2) docker-compose-local.yml"
    echo -e "3) docker-compose-dev.yml"
    echo -e "4) Others"
    echo -e "5) Quit"

    read -p "Your Docker Compose File Name ? : " opt

    case $opt in
        "1")
            DOCKER_COMPOSE_FILE_NAME="docker-compose.yml";;
        "2")
            DOCKER_COMPOSE_FILE_NAME="docker-compose-local.yml";;
        "3")
            DOCKER_COMPOSE_FILE_NAME="docker-compose-dev.yml";;
        "4")
            read -p "Enter your custom file name : " DOCKER_COMPOSE_FILE_NAME;;
        "5")
            exit 0;;
        *)
            echo "invalid option $REPLY";;
    esac
}

if [ $# -gt 0 ]; then
    # Create dockr file in project root directory.
    if [ "$1" == "init" ]; then
        shift 1

        BASEDIR=$(dirname "$0")

        if [ -f $(pwd)/dockr ]; then
            echo -e "${RED}Dockr exec file already exists.${CLR}" >&2
            echo -e "If you want to create a new Dockr exec file,"
            echo -e "Remove the existing file manually or by running : \"${BLUE}dockr_setup remove${CLR}\""
        else
            echo -e "${RED}-----------------------------------------${CLR}"

            get_php_version

            echo -e "${RED}-----------------------------------------${CLR}"

            get_docker_compose_file_name

            echo -e "${RED}-----------------------------------------${CLR}"

            rm -rf "$BASEDIR"/temp
            mkdir "$BASEDIR"/temp
            touch "$BASEDIR"/temp/dockr

            cat "$BASEDIR"/dockr_files/env >> "$BASEDIR"/temp/dockr

            echo "" >> "$BASEDIR"/temp/dockr
            echo "export DOCKER_COMPOSE_FILE=\"${DOCKER_COMPOSE_FILE_NAME}\"" >> "$BASEDIR"/temp/dockr
            echo "export DOCKER_CONTAINER=\"${CONTAINER_IMAGE}\"" >> "$BASEDIR"/temp/dockr
            echo "" >> "$BASEDIR"/temp/dockr

            cat "$BASEDIR"/dockr_files/commands >> "$BASEDIR"/temp/dockr

            mv "$BASEDIR"/temp/dockr "$(pwd)"/dockr
            chmod u+x "$(pwd)"/dockr

            rm -rf "$BASEDIR"/temp
        fi

    # Remove existing Dockr File
    elif [ "$1" == "remove" ]; then
        shift 1

        if [ -f "$(pwd)"/dockr ]; then
          rm -rf "$(pwd)"/dockr
          echo -e "${GREEN}Dockr exec file removed successfully ${CLR}"
        else
          echo -e "${YELLOW}Dockr File does not exists.${CLR}"
        fi

        exit 0

    # Some other ...
    elif [ "$1" == "test" ]; then
        shift 1

        echo -e "${YELLOW} Yellow.${CLR}" >&2
        echo -e "${BLUE} Blue.${CLR}" >&2
        echo -e "${RED} Red.${CLR}" >&2
        echo -e "${GREEN} Green.${CLR}" >&2
        echo -e "${WHITE} White.${CLR}" >&2
        echo -e "${MAGENTA} Magenta.${CLR}" >&2
        echo -e "${CYAN} Cyan.${CLR}" >&2
        echo -e "${BLACK} Black.${CLR}" >&2

        echo -e "${YELLOW_BG}${BLACK} Yellow BG.${CLR}" >&2
        echo -e "${YELLOW_BG} Yellow BG.${CLR}" >&2
        echo -e "${BLUE_BG} Blue BG.${CLR}" >&2
        echo -e "${RED_BG} Red BG.${CLR}" >&2
        echo -e "${GREEN_BG} Green BG.${CLR}" >&2
        echo -e "${WHITE_BG} White BG.${CLR}" >&2
        echo -e "${MAGENTA_BG} Magenta BG.${CLR}" >&2
        echo -e "${CYAN_BG} Cyan BG.${CLR}" >&2
        echo -e "${BLACK_BG} Black BG.${CLR}" >&2

        echo -e "${RED}-----------------------------------------${CLR}"
    fi

    echo $1
fi
