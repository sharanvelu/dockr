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

## DOCKR_BRANCH

## DIRECTORY
DOCKR_DIR_HOME="${HOME}/Dockr"
DOCKR_DIR_FILES="${DOCKR_DIR_HOME}/dockr_files"

# FILES NAME
DOCKR_FILES_SETUP="dockr_setup"
DOCKR_FILES_COMMANDS="commands"
DOCKR_FILES_ENV="env"
DOCKR_FILES_RC=".dockr_rc"
DOCKR_FILES_DOCKR="dockr"

## Dockr Directory
rm -rf "${DOCKR_DIR_HOME}"
mkdir "${DOCKR_DIR_HOME}"

## Dockr Setup File
curl -fsSL "https://raw.githubusercontent.com/sharanvelu/dockr/${DOCKR_BRANCH}/dockr_setup.sh" >> "${DOCKR_DIR_HOME}/${DOCKR_FILES_SETUP}"

mkdir "${DOCKR_DIR_FILES}"
curl -fsSL "https://raw.githubusercontent.com/sharanvelu/dockr/${DOCKR_BRANCH}/dockr_files/env" >> "${DOCKR_DIR_FILES}/${DOCKR_FILES_ENV}"
curl -fsSL "https://raw.githubusercontent.com/sharanvelu/dockr/${DOCKR_BRANCH}/dockr_files/commands" >> "${DOCKR_DIR_FILES}/${DOCKR_FILES_COMMANDS}"

## DOCKR
curl -fsSL "https://raw.githubusercontent.com/sharanvelu/dockr/${DOCKR_BRANCH}/dockr" >> "${DOCKR_DIR_HOME}/${DOCKR_FILES_DOCKR}"
PATH=$PATH:$DOCKR_DIR_HOME

# Alias File
curl -fsSL "https://raw.githubusercontent.com/sharanvelu/dockr/${DOCKR_BRANCH}/.dockr_rc" >> "${DOCKR_DIR_HOME}/${DOCKR_FILES_RC}"
. "${DOCKR_DIR_HOME}/${DOCKR_FILES_RC}"

echo "Files initiation Complete."
echo "Kindly run \033[1;34m\"\033[1;33m. ${DOCKR_DIR_HOME}/${DOCKR_FILES_RC}\033[1;34m\"\033[0m to Complete the installation"
