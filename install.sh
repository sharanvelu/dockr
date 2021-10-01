#!/bin/sh

# This script should be run via curl:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/sharanvelu/dockr/release/install.sh)"
# or via wget:
#   sh -c "$(wget -qO- https://raw.githubusercontent.com/sharanvelu/dockr/release/install.sh)"
# or via fetch:
#   sh -c "$(fetch -o - https://raw.githubusercontent.com/sharanvelu/dockr/release/install.sh)"
#
# Then Run from your terminal
#   . ~/.dockr/dockr_rc

echo "Beginning Installation..."

## DIRECTORY
DOCKER_DIR_HOME="${HOME}/.dockr"
DOCKER_DIR_FILES="${DOCKER_DIR_HOME}/dockr_files"

# FILES NAME
DOCKER_FILES_SETUP="dockr_setup.sh"
DOCKER_FILES_COMMANDS="commands"
DOCKER_FILES_ENV="env"
DOCKER_FILES_RC=".dockr_rc"

## Dockr Directory
rm -rf "${DOCKER_DIR_HOME}"
mkdir "${DOCKER_DIR_HOME}"

## Dockr Setup File
curl -fsSL https://raw.githubusercontent.com/sharanvelu/dockr/release/dockr_setup.sh >> "${DOCKER_DIR_HOME}/${DOCKER_FILES_SETUP}"

mkdir "${DOCKER_DIR_FILES}"
curl -fsSL https://raw.githubusercontent.com/sharanvelu/dockr/release/dockr_files/env >> "${DOCKER_DIR_FILES}/${DOCKER_FILES_ENV}"
curl -fsSL https://raw.githubusercontent.com/sharanvelu/dockr/release/dockr_files/commands >> "${DOCKER_DIR_FILES}/${DOCKER_FILES_COMMANDS}"

# Alias File
curl -fsSL https://raw.githubusercontent.com/sharanvelu/dockr/release/.dockr_rc >> "${DOCKER_DIR_HOME}/${DOCKER_FILES_RC}"
. "${DOCKER_DIR_HOME}/${DOCKER_FILES_RC}"

echo "Files initiation Complete."
echo "Kindly run \033[1;34m\"\033[1;33m. ${DOCKER_DIR_HOME}/${DOCKER_FILES_RC}\033[1;34m\"\033[0m to Complete the installation"
