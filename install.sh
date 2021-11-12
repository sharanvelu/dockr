#!/bin/bash

## Dockr by Sharan

# This script should be run via curl:
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/sharanvelu/dockr/release/install.sh)"
# or via wget:
#   bash -c "$(wget -qO- https://raw.githubusercontent.com/sharanvelu/dockr/release/install.sh)"
# or via fetch:
#   bash -c "$(fetch -o - https://raw.githubusercontent.com/sharanvelu/dockr/release/install.sh)"

CLR='\033[0m'
RED='\033[1;31m'
GREEN='\033[1;32m'

## Dockr Branch
DOCKR_BRANCH="release"

## DIRECTORY
DOCKR_DIR_HOME="${HOME}/Dockr"
DOCKR_DIR_TEMP="${HOME}/Dockr_TEMP"

# FILES NAME
DOCKR_FILES_DOCKR="dockr"
DOCKR_FILES_DOCKER_COMPOSE_GLOBAL="dockr-compose.yml"
DOCKR_FILES_DOCKER_COMPOSE_ASSET="dockr-compose-asset.yml"

# Display Process
display_process() {
    echo -e ""
    echo -e "$*"
}

# Exit the Installation Process
exiting() {
    echo -e ""
    echo -e "${RED}${*}${CLR}"
    echo -e "Exiting the installation Process..."

    rm -rf "${DOCKR_DIR_TEMP}"

    exit 1
}

# Check if the given command is available or not!
command_exists() {
    command -v "$@" >/dev/null 2>&1
}

system_check() {
    # Verifying operating system
    case "$(uname -s)" in
        Linux*) ;;
        Darwin*) ;;
        *)
          echo "OS (operating system) ([$(uname -s)]) not supported." >&2
          echo "Dockr supports macOS, Linux, and Windows (WSL2)." >&2
          exit 1
    esac
}

# Initialize Dockr Directory
init_dockr_directory() {
    rm -rf "${DOCKR_DIR_TEMP}"
    mkdir "${DOCKR_DIR_TEMP}"
    mkdir "${DOCKR_DIR_TEMP}/res"
    mkdir "${DOCKR_DIR_TEMP}/res/bin"
}

# Setup Dockr Binary Files
setup_dockr_files() {
    display_process "Adding binary files for Dockr..."

    ## DOCKR
    curl -fsSL "https://raw.githubusercontent.com/sharanvelu/dockr/${DOCKR_BRANCH}/dockr" >> "${DOCKR_DIR_TEMP}/${DOCKR_FILES_DOCKR}"

    ## dockr-compose Files
    curl -fsSL "https://raw.githubusercontent.com/sharanvelu/dockr/${DOCKR_BRANCH}/res/dockr-compose.yml" >> "${DOCKR_DIR_TEMP}/res/${DOCKR_FILES_DOCKER_COMPOSE_GLOBAL}"
    curl -fsSL "https://raw.githubusercontent.com/sharanvelu/dockr/${DOCKR_BRANCH}/dockr-compose-asset.yml" >> "${DOCKR_DIR_TEMP}/${DOCKR_FILES_DOCKER_COMPOSE_ASSET}"
}

# Add Hosts entry For Dockr
add_host_entry() {
    display_process "Adding Hosts Entry for Dockr Network..."

    if ! grep -q -w "dockr" /etc/hosts; then
        echo -e "Please enter your system password (if prompted)!"
        {
            echo ""
            echo "# Added by Dockr"
            echo "127.0.0.1 dockr"
        } | sudo tee -a /etc/hosts > /dev/null
    else
        sleep 1
        echo -e "Hosts entry already exists. Skipping..."
    fi
}

# Finish Setup by transferring Temp dir to Dockr dir.
finalize_setup() {
    display_process "Finalizing Dockr Setup..."
    rm -rf "${DOCKR_DIR_HOME}"
    mv "${DOCKR_DIR_TEMP}" "${DOCKR_DIR_HOME}"

    rm -rf /usr/local/bin/dockr
    ln "${DOCKR_DIR_HOME}"/dockr /usr/local/bin/dockr

    chmod u+x "${DOCKR_DIR_HOME}"/dockr
}

print_dockr_success() {
    echo -e "${RED}"
    printf '     ______    _______ _____ __   __   _______  \n'
    printf '    /  ___  \ /  ___  / ___//  / / /  /  __  /  \n'
    printf '   /  /   | |/ /   / / /   /  //  /  /  / / /   \n'
    printf '  /  /   /  / /   / / /   /   -,^   /  /_/ /    \n'
    printf ' /  /___/  / /___/ / /___/  /\  \  /  /\  \     \n'
    printf '/_________/_______/_____/__/  \__\/__/  \__\    \n'
    echo -e "${CLR}"
    printf '       ___  .  . .    ___  .     .    .         \n'
    printf '      /__  /--/ /_\  /__/ /_\   / \  /          \n'
    printf 'BY   ___/ /  / /   \/ |  /   \ /   \/           \n'

    display_process "...is now ${GREEN}successfully${CLR} installed!"
}

echo -e "Beginning Installation..."

system_check

init_dockr_directory

setup_dockr_files

add_host_entry

finalize_setup

print_dockr_success
