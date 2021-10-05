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
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'

## Dockr Branch
DOCKR_BRANCH="global-dockr"

## DIRECTORY
DOCKR_DIR_HOME="${HOME}/Dockr"
DOCKR_DIR_TEMP="${HOME}/Dockr_TEMP"

# FILES NAME
DOCKR_FILES_DOCKR="dockr"
DOCKR_FILES_SETUP="dockr_setup"
DOCKR_FILES_ALIAS=".dockr_aliases"
FILES_GITIGNORE=".gitignore_global"
DOCKR_FILES_DOCKER_COMPOSE_PROJECT="docker-compose-local.yml"
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

# Determine the current Shell for the logged in User.
shell_check() {
    while IFS='/' read -ra ADDR; do
        for i in "${ADDR[@]}"; do
            CURRENT_SHELL_NAME="$i"
        done
    done <<< "$SHELL"
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

    ## Dockr Setup File
    curl -fsSL "https://raw.githubusercontent.com/sharanvelu/dockr/${DOCKR_BRANCH}/res/bin/dockr_setup.sh" >> "${DOCKR_DIR_TEMP}/res/bin/${DOCKR_FILES_SETUP}"

    ## DOCKR
    curl -fsSL "https://raw.githubusercontent.com/sharanvelu/dockr/${DOCKR_BRANCH}/dockr" >> "${DOCKR_DIR_TEMP}/${DOCKR_FILES_DOCKR}"

    ## dockr-compose Files
    curl -fsSL "https://raw.githubusercontent.com/sharanvelu/dockr/${DOCKR_BRANCH}/res/dockr-compose.yml" >> "${DOCKR_DIR_TEMP}/res/${DOCKR_FILES_DOCKER_COMPOSE_GLOBAL}"
    curl -fsSL "https://raw.githubusercontent.com/sharanvelu/dockr/${DOCKR_BRANCH}/dockr-compose-asset.yml" >> "${DOCKR_DIR_TEMP}/${DOCKR_FILES_DOCKER_COMPOSE_ASSET}"
}

# Setup Alias File
# Add alias file to shell rc file
setup_alias_file() {
    display_process "Adding Alias Files for Dockr..."

    # Create RC File
    touch "${DOCKR_DIR_TEMP}/res/${DOCKR_FILES_ALIAS}"
    # Add RC File Content
    {
        echo -e "## Dockr Executable"
        echo -e "alias dockr=\"${DOCKR_DIR_HOME}/${DOCKR_FILES_DOCKR}\""
    } >> "${DOCKR_DIR_TEMP}/res/${DOCKR_FILES_ALIAS}"

    chmod u+x "${DOCKR_DIR_TEMP}/${DOCKR_FILES_DOCKR}"

    case $CURRENT_SHELL_NAME in
        "zsh") SHELL_RC="${HOME}/.zshrc";;
        "bash") SHELL_RC="${HOME}/.bashrc";;
        *)
            echo -e "Shell ${RED}${CURRENT_SHELL_NAME} is not supported${CLR} for now."
            exiting "Supported Shells are ${YELLOW}ZSH${CLR}, ${YELLOW}BASH${CLR}.";;
    esac

    if [ ! -f "$SHELL_RC" ]; then
        touch "$SHELL_RC"
    fi

    if ! grep -q "${DOCKR_FILES_ALIAS}" "$SHELL_RC"; then
        {
            echo -e ""
            echo -e "# Dockr related Alias File"
            echo -e ". ${DOCKR_DIR_HOME}/res/${DOCKR_FILES_ALIAS}"
        } >> "${SHELL_RC}"
        DOCKR_ALIAS_FILE_ADDED=1
    fi
}

# Add Hosts entry For Dockr
add_host_entry() {
    display_process "Adding Hosts Entry for Dockr Networking..."

    if ! grep -q "dockr.host" /etc/hosts; then
        echo -e "Enter your system password (if prompted)!"
        {
            echo ""
            echo "# Added by Dockr"
            echo "127.0.0.1 dockr.host"
        } | sudo tee -a /etc/hosts > /dev/null
    else
        echo -e "Hosts entry already exists..."
    fi
}

# Add Files to Global Gitignore.
setup_gitignore() {
    display_process "Configuring Global Gitignore..."

    echo -e "Checking ${CYAN}git${CLR} installation..."
    command_exists git || {
        exiting "git is not installed..."
    }

    if ! git config --global -l | grep -q "core.excludesfile"
    then
        echo -e "Global gitignore is ${RED}not set.${CLR}"
        echo -e "Setting up global gitignore."

        if [ ! -f "${HOME}/${FILES_GITIGNORE}" ]; then
            touch "${HOME}/${FILES_GITIGNORE}"
        fi

        echo -e "Global Gitignore configuration ${GREEN}successful${CLR}."
        echo -e "Global Gitignore file is set to : ${CYAN}${FILES_GITIGNORE}${CLR}."
        GITIGNORE_FILE="${HOME}/${FILES_GITIGNORE}"
    else
        GITIGNORE_FILE="$(git config --get core.excludesfile)"
    fi

    if ! grep -q "${DOCKR_FILES_DOCKER_COMPOSE_PROJECT}" "${GITIGNORE_FILE}"
    then
        echo -e "${DOCKR_FILES_DOCKER_COMPOSE_PROJECT}" >> "${GITIGNORE_FILE}"
        echo -e "${YELLOW}${DOCKR_FILES_DOCKER_COMPOSE_PROJECT}${CLR} Added to ${CYAN}global gitignore file${CLR}."
    else
        echo -e "Global gitignore already configured..."
    fi
}

# Finish Setup by transferring Temp dir to Dockr dir.
finalize_setup() {
    display_process "Finalizing Dockr Setup..."
    rm -rf "${DOCKR_DIR_HOME}"
    mv "${DOCKR_DIR_TEMP}" "${DOCKR_DIR_HOME}"

    if [ -n "$DOCKR_ALIAS_FILE_ADDED" ]; then
        display_process "Files initiation Complete..."
        echo -e "Kindly run ${BLUE}\"${YELLOW}source ${SHELL_RC}${BLUE}\"${CLR} to Complete the installation"
    else
        display_process "Dockr Installation Completed..."
    fi
}

echo -e "Beginning Installation..."

system_check

shell_check

init_dockr_directory

setup_dockr_files

setup_alias_file

setup_gitignore

add_host_entry

finalize_setup
