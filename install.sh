#!/bin/bash

## Dockr by Sharan

# This script should be run via curl:
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/sharanvelu/dockr/release/install.sh)"
# or via wget:
#   bash -c "$(wget -qO- https://raw.githubusercontent.com/sharanvelu/dockr/release/install.sh)"
# or via fetch:
#   bash -c "$(fetch -o - https://raw.githubusercontent.com/sharanvelu/dockr/release/install.sh)"

## Exit when an error occurs instead of continuing the rest.
set -e

CLR='\033[0m'
RED='\033[1;31m'
GREEN='\033[1;32m'
BOLD='\033[1m'

## Dockr Branch
DOCKR_BRANCH="release"

## Dockr Name
DOCKR_NAME="DockR"

## DIRECTORY
DOCKR_DIR_HOME="${HOME}/dockr"
DOCKR_DIR_BIN="/usr/local/bin"

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
        display_process "Getting ${DOCKR_NAME} from git."
        git clone --single-branch --branch "${DOCKR_BRANCH}" --no-tags -q https://github.com/sharanvelu/dockr.git "${DOCKR_DIR_HOME}"

    # Update Dockr
    elif [ "$1" == "update" ]; then
        # If existing dockr is not a git repository, remove the existing dir and add it as git repo.
        if [ ! -d "${DOCKR_DIR_HOME}/.git" ]; then
            rm -rf "${DOCKR_DIR_HOME}"
            git_perform "install"

        # Dockr is already a git repo. Pull the latest version.
        else
            echo "${DOCKR_NAME} already exists. Trying to update ${DOCKR_NAME} using git..."
            CURRENT_DIR="$(pwd)"
            cd "${DOCKR_DIR_HOME}" || exiting "Unable to locate dir ${DOCKR_DIR_HOME}"
            git reset --hard -q
            git checkout -q "${DOCKR_BRANCH}"
            display_process "Pulling latest changes from git."
            git pull -q
            cd "${CURRENT_DIR}" || exiting "Unable to locate dir ${CURRENT_DIR}"
        fi
    fi
}

# Finish Setup by transferring Temp dir to Dockr dir.
finalize_setup() {
    display_process "Finalizing Dockr Setup..."

    # Update dockr executable by creating a symlink
    rm -rf "${DOCKR_DIR_BIN}/dockr"

    if [ ! -d /usr/local ]; then
        sudo mkdir /usr/local
    fi

    if [ ! -d "${DOCKR_DIR_BIN}" ]; then
        sudo mkdir "${DOCKR_DIR_BIN}"
    fi

    sudo ln -s "${DOCKR_DIR_HOME}/dockr" "${DOCKR_DIR_BIN}/dockr"
}

# Add necessary permissions for necessary files / directories.
add_permissions() {
    # Give Permission for dockr executables
    chmod u+x "${DOCKR_DIR_HOME}/dockr"

    # Give permission to /usr/local/bin directory to the current user
    sudo chown -R `whoami` "${DOCKR_DIR_BIN}"
}

# Do specific actions related to the OS
os_specific_actions() {
    # Execute some commands if the system is Linux using WSL kernel
    if is_wsl
    then
        wsl_specific_command
    fi

    # Execute some commands if the system is mac
    if is_mac
    then
        # Execute specific commands if the system is M1 based Mac
        if is_mac_m1
        then
            mac_specific_command
        fi
    fi
}

# check if the machine is Linux using WSL
is_wsl() {
	case "$(uname -r)" in
	    *microsoft* ) true ;; # WSL 2
        *Microsoft* ) true ;; # WSL 1
        * ) false;;
	esac
}

# check if the machine is MacOS
is_mac() {
	case "$(uname -s)" in
        *darwin* ) true ;;
        *Darwin* ) true ;;
        * ) false;;
	esac
}

# check if the machine is M1 based Mac
is_mac_m1() {
	case "$(uname -m)" in
        *arm64* ) true ;;
        *arm* ) true ;;
        * ) false;;
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
    echo -e "${RED}"
    printf '           ___                       _______ \n'
    printf '          /  /_____ ____   __   __  /  __  / \n'
    printf '   ______/  /  __  / __/ /  / /  / /  / / /  \n'
    printf '  /  ___   / /  / / /   /  //_ /  /  /_/_/   \n'
    printf ' /  /__/  / /__/ / /__ /  /\  \  /  /\ \     \n'
    printf '/________/______/____//__/  \__\/__/  \_\    \n'

    echo -e "${CLR}"
#    printf '       ___  .  . .    ___  .     .    .         \n'
#    printf '      /__  /--/ /_\  /__/ /_\   / \  /          \n'
#    printf 'BY   ___/ /  / /   \/ |  /   \ /   \/           \n'
    echo -e "                           By --${BOLD} SHARAN ${CLR}--"

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

add_permissions

os_specific_actions

print_dockr_success "$INSTALL_TYPE"
