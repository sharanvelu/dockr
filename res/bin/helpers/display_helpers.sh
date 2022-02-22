#!/bin/bash

## DockR by Sharan

# Display DockR container is not running and Terminate.
dockr_is_down() {
    echo -e "${RED}No ${BOLD}${DOCKR_NAME} container is running from this Directory.${CLR}\n"
    echo -e "${BOLD}Please check the directory.${CLR} Or"
    echo -e "${BOLD}Run ${DOCKR_NAME} using ${YELLOW}\"dockr up\"${CLR}"

    exit 1
}

# Display DockR Asset Containers are not running and Terminate.
dockr_asset_container_not_running() {
    echo -e "${BOLD}${DOCKR_NAME} Asset container \"$1\" is ${RED}not running.${CLR}\n"
    echo -e "${BOLD}You can run ${DOCKR_NAME} asset container using ${YELLOW}\"dockr asset up\"${CLR}"

    exit 1
}

# Display DockR Container is stopped and Terminate.
dockr_container_is_stopped() {
    echo -e "${BOLD}The ${DOCKR_NAME} container${CLR}(s) ${BOLD}is ${RED}stopped.${CLR}"
    echo ""
    echo -e "${BOLD}You can start the ${DOCKR_NAME} container${CLR}(s) ${BOLD}using ${YELLOW}\"dockr up\"${CLR}"

    exit 1
}

# Display DockR Asset Containers are stopped and Terminate.
dockr_asset_container_is_stopped() {
    echo -e "${BOLD}The ${DOCKR_NAME} asset container \"$1\" is ${RED}stopped.${CLR}"
    echo ""
    echo -e "${BOLD}You can start the ${DOCKR_NAME} asset container${CLR}(s) ${BOLD}using the following command:${CLR}"
    echo -e "${YELLOW}\"dockr asset up\"${CLR}"

    exit 1
}

# Display Help command
display_help() {
    . "${DOCKR_BIN_DIR}/help.sh"
}

# Display DockR Name
display_dockr_name() {
    echo -e "\n-- ${DOCKR_NAME} --\n"
}
