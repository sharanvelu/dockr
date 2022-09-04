#!/bin/bash

## DockR by Sharan

# This script should be run via curl:
#   bash -c "$(curl -fsSL install.dockr.in)"
# or via wget:
#   bash -c "$(wget -qO- install.dockr.in)"
# or via fetch:
#   bash -c "$(fetch -o - install.dockr.in)"

## Exit when an error occurs instead of continuing the rest.
set -e

# Font Styling and Colors
CLR="\033[0m"
RED="\033[38;5;196m"
GREEN="\033[38;3;32m"
ORANGE="\033[38;5;202m"
LAVENDER="\033[38;5;093m"
PINK="\033[38;5;163m"
BOLD="\033[1m"
CYAN="\033[1;36m"

# Process Indicator
PROCESS="${CYAN}=>${CLR} "

# Git Tag and Branch
DOCKR_TAG="v1.5.1"

## DockR NAME, KEY
DOCKR_KEY="dockr"
DOCKR_NAME="DockR"

## DIRECTORY
DOCKR_DIR_HOME="${HOME}/${DOCKR_KEY}"
DOCKR_DIR_BIN="/usr/local/bin"
DOCKR_DIR_DATA="${HOME}/.${DOCKR_KEY}"

## Config File
DOCKR_FILE_CONFIG="${DOCKR_DIR_DATA}/config"

# Display Process
display_process() {
    echo -e "\n${PROCESS}$*"
}

# Exit the Installation Process
exiting() {
    echo -e "\n${RED}${*}${CLR}"
    echo -e "${RED}=>${CLR} Exiting the installation Process..."

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
        ;;
    esac
}

# Add Hosts entry For DockR
add_host_entry() {
    display_process "Adding Hosts Entry for ${DOCKR_NAME} Network..."

    if ! grep -q -w "${DOCKR_KEY}" /etc/hosts; then
        echo -e "Please enter your system password (if prompted)!"
        {
            echo ""
            echo "# Added by ${DOCKR_NAME}"
            echo "127.0.0.1 ${DOCKR_KEY}"
        } | sudo tee -a /etc/hosts >/dev/null
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

    # Install DockR
    if [ "$1" == "install" ]; then
        display_process "Getting ${DOCKR_NAME} from git."
        ## DockR Branch
        if echo "$*" | grep -q -w "\-\-dev"; then
            git clone --branch "${DT_BRANCH}" -q https://github.com/sharanvelu/dockr.git "${DOCKR_DIR_HOME}"
        else
            git clone -b ${DOCKR_TAG} -q https://github.com/sharanvelu/dockr.git "${DOCKR_DIR_HOME}" >/dev/null 2>&1
        fi


    # Update DockR
    elif [ "$1" == "update" ]; then
        # If existing dockr is not a git repository, remove the existing dir and add it as git repo.
        if [ ! -d "${DOCKR_DIR_HOME}/.git" ]; then
            rm -rf "${DOCKR_DIR_HOME}"
            git_perform "install"

        # DockR is already a git repo. Pull the latest version.
        else
            echo "${DOCKR_NAME} already exists. Trying to update ${DOCKR_NAME} using git..."
            CURRENT_DIR="$(pwd)"
            cd "${DOCKR_DIR_HOME}" || exiting "Unable to locate dir ${DOCKR_DIR_HOME}"
            git reset --hard -q
            display_process "Pulling latest changes from git."
            git fetch -q
            if echo "$*" | grep -q -w "\-\-dev"; then
                git checkout -q "${DT_BRANCH}"
                git pull -q
            else
                git checkout -q tags/${DOCKR_TAG}
            fi
            cd "${CURRENT_DIR}" || exiting "Unable to locate dir ${CURRENT_DIR}"
        fi
    fi
}

# Finish Setup by transferring Temp dir to DockR dir.
finalize_setup() {
    display_process "Finalizing ${DOCKR_NAME} Setup..."

    # Remove the dockr bin file
    rm -rf "${DOCKR_DIR_BIN}/${DOCKR_KEY}"

    if [ ! -d "${DOCKR_DIR_BIN}" ]; then
        sudo mkdir -p "${DOCKR_DIR_BIN}"
    fi

    # Update dockr executable by creating a symlink
    sudo ln -s "${DOCKR_DIR_HOME}/${DOCKR_KEY}" "${DOCKR_DIR_BIN}/${DOCKR_KEY}"

    # Setup .dockr data folder
    if [ ! -d "${DOCKR_DIR_DATA}" ]; then
        mkdir "${DOCKR_DIR_DATA}"
    fi

    # Setup asset config File
    if [ ! -f "${DOCKR_FILE_CONFIG}" ]; then
        touch "${DOCKR_FILE_CONFIG}"
    fi
}

# Add necessary permissions for necessary files / directories.
add_permissions() {
    # Give Permission for dockr executables
    chmod u+x "${DOCKR_DIR_HOME}/${DOCKR_KEY}"

    # Give permission to /usr/local/bin directory to the current user
    sudo chown -R $(whoami) "${DOCKR_DIR_BIN}"

    # Give permission to Data directory to the current user
    sudo chown -R $(whoami) "${DOCKR_DIR_DATA}"
}

# Do specific actions related to the OS
os_specific_actions() {
    # Execute some commands if the system is Linux using WSL kernel
    if is_wsl; then
        wsl_specific_command
    fi

    # Execute some commands if the system is mac
    if is_mac; then
        # Execute specific commands if the system is M1 based Mac
        if is_mac_m1; then
            mac_specific_command
        fi
    fi
}

# check if the machine is Linux using WSL
is_wsl() {
    case "$(uname -r)" in
    *microsoft*) true ;; # WSL 2
    *Microsoft*) true ;; # WSL 1
    *) false ;;
    esac
}

# check if the machine is MacOS
is_mac() {
    case "$(uname -s)" in
    *darwin*) true ;;
    *Darwin*) true ;;
    *) false ;;
    esac
}

# check if the machine is M1 based Mac
is_mac_m1() {
    case "$(uname -m)" in
    *arm64*) true ;;
    *arm*) true ;;
    *) false ;;
    esac
}

# Execute Windows specific commands if any
wsl_specific_command() {
    true
}

# Execute Mac Os specific commands if any
mac_specific_command() {
    true
}

print_dockr_success() {
    MULTI_COLORS="
      $(printf ${RED})
      $(printf ${ORANGE})
      $(printf ${GREEN})
      $(printf ${LAVENDER})
      $(printf ${PINK})
      $(printf ${CLR})
    "

    printf '     %s      ___ %s        %s      %s          %s_______  %s\n' $MULTI_COLORS
    printf '    %s      /  /%s ______ %s____  %s __   __  %s/  __  / %s \n' $MULTI_COLORS
    printf '   %s______/  /%s/  __  /%s/ __/ %s/  / /  / %s/  / / / %s  \n' $MULTI_COLORS
    printf '  %s/  ___   /%s/ /  / /%s/ /   %s/  //_ /  %s/  /_/_/ %s   \n' $MULTI_COLORS
    printf ' %s/  /__/  /%s/ /__/ /%s/ /__ %s/  /\  \  %s/  /\ \  %s    \n' $MULTI_COLORS
    printf '%s/________/%s/______/%s/____/%s/__/  \__\%s/__/  \_\%s     \n' $MULTI_COLORS

    echo -e "${CLR}"
    echo -e "                           By --${BOLD}${CYAN} SHARAN ${CLR}--\n"

    if [ "$1" == "install" ]; then
        echo -e "\t ...is now ${GREEN}successfully${CLR} installed!"
    fi

    if [ "$1" == "update" ]; then
        echo -e "\t\t...is ${GREEN}successfully${CLR} updated!"
    fi
}

echo -e "Beginning Installation..."

system_check

INSTALL_TYPE="install"
installation_type_check

git_perform ${INSTALL_TYPE}

add_host_entry

finalize_setup

add_permissions

#os_specific_actions

print_dockr_success "$INSTALL_TYPE"
