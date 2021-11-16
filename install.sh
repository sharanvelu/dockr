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

## Dockr Name
DOCKR_NAME="Dockr"

## DIRECTORY
DOCKR_DIR_HOME="${HOME}/dockr"

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

    exit 1
}

# Check if the given command is available or not!
command_exists() {
    command -v "$@" >/dev/null 2>&1
}

# Verifying operating system
system_check() {
    case "$(uname -s)" in
        Linux*) ;;
        Darwin*) ;;
        *)
          echo "OS (operating system) ([$(uname -s)]) not supported." >&2
          echo "${DOCKR_NAME} supports macOS, Linux, and Windows (WSL2)." >&2
          exit 1
    esac
}

# Add Hosts entry For Dockr
add_host_entry() {
    display_process "Adding Hosts Entry for ${DOCKR_NAME} Network..."

    if ! grep -q -w "dockr" /etc/hosts; then
        echo -e "Please enter your system password (if prompted)!"
        {
            echo ""
            echo "# Added by ${DOCKR_NAME}"
            echo "127.0.0.1 dockr"
        } | sudo tee -a /etc/hosts > /dev/null
    else
        sleep 1
        echo -e "Hosts entry already exists. Skipping..."
    fi
}

installation_type_check() {
    if [ -d "${DOCKR_DIR_HOME}" ]; then
        INSTALL_TYPE="update"
    fi
}

git_perform() {
    command_exists git || {
        exiting "Git isn't available or not installed correctly."
    }

    # Install Dockr
    if [ "$1" == "install" ]; then
        git clone --single-branch --branch "${DOCKR_BRANCH}" --no-tags https://github.com/sharanvelu/dockr.git "${DOCKR_DIR_HOME}"

    # Update Dockr
    elif [ "$1" == "update" ]; then
        # If existing dockr is not a git repository, remove the existing dir and add it as git repo.
        if [ ! -d "${DOCKR_DIR_HOME}/.git" ]; then
            display_process "Updating ${DOCKR_NAME} with latest git branch."
            rm -rf "${DOCKR_DIR_HOME}"
            git_perform "install"

        # Dockr is already a git repo. Pull the latest version.
        else
            echo "${DOCKR_NAME} already exists. Trying to update ${DOCKR_NAME} using git..."
            CURRENT_DIR="$(pwd)"
            cd "${DOCKR_DIR_HOME}" || exiting "Unable to locate dir ${DOCKR_DIR_HOME}"
            git reset --hard -q
            git checkout -q "${DOCKR_BRANCH}"
            git pull
            cd "${CURRENT_DIR}" || exiting "Unable to locate dir ${CURRENT_DIR}"
        fi
    fi
}

# Finish Setup by transferring Temp dir to Dockr dir.
finalize_setup() {
    display_process "Finalizing Dockr Setup..."

    # Give Permission for dockr executables
    chmod u+x "${DOCKR_DIR_HOME}/dockr"

    # Update dockr executable by creating a symlink
    rm -rf /usr/local/bin/dockr
    ln -s "${DOCKR_DIR_HOME}/dockr" /usr/local/bin/dockr
}

print_dockr_success() {
    echo -e "${RED}"
    printf '     ______    _______ _____ __   __   _______  \n'
    printf '    /  ___  \ /  ___  / ___//  / / /  /  __  /  \n'
    printf '   /  /   | |/ /   / / /   /  //  /  /  / / /   \n'
    printf '  /  /   /  / /   / / /   /   -,^   /  /_/ /    \n'
    printf ' /  /___/  / /___/ / /___/  /\  \  /  /\  \     \n'
    printf '/_________/_______/_____/__/  \__\/__/  \__\    \n'

#    printf '     ______                            ________ \n'
#    printf '    /  ___  \ _______ ____   __  __   /  ___  / \n'
#    printf '   /  /   | |/  ___  / __/ /  //  /  /  /  / /  \n'
#    printf '  /  /   /  / /   / / /   /   --"   /  /__/_/   \n'
#    printf ' /  /___/  / /___/ / /__ /  /\  \  /  /\  \     \n'
#    printf '/_________/_______/____//__/  \__\/__/  \__\    \n'

    echo -e "${CLR}"
    printf '       ___  .  . .    ___  .     .    .         \n'
    printf '      /__  /--/ /_\  /__/ /_\   / \  /          \n'
    printf 'BY   ___/ /  / /   \/ |  /   \ /   \/           \n'

    if [ "$1" == "install" ]; then
        display_process "...is now ${GREEN}successfully${CLR} installed!"
    fi

    if [ "$1" == "update" ]; then
        display_process "...is ${GREEN}successfully${CLR} updated!"
    fi
}

echo -e "Beginning Installation..."

system_check

INSTALL_TYPE="install"
installation_type_check

git_perform ${INSTALL_TYPE}

add_host_entry

finalize_setup

print_dockr_success "$INSTALL_TYPE"
