#!/bin/bash

## DockR by Sharan

# Display DockR container is not running and Terminate.
dockr_is_down() {
    echo -e "${RED}No ${BOLD}${DOCKR_NAME} container is running from this Directory.${CLR}\n"
    echo -e "${BOLD}Please check the directory.${CLR} Or"
    echo -e "${BOLD}Run ${DOCKR_NAME} using ${CYAN}\"dockr up\"${CLR}"

    exit 1
}

# Display DockR Container is stopped and Terminate.
dockr_container_is_stopped() {
    echo -e "${BOLD}The ${DOCKR_NAME} Container${CLR}(s) ${BOLD}are ${RED}stopped.${CLR}"
    echo ""
    echo -e "${BOLD}You can start the ${DOCKR_NAME} container${CLR}(s) ${BOLD}using ${CYAN}\"dockr up\"${CLR}"

    exit 1
}

# Display DockR Asset Containers are not running and Terminate.
dockr_asset_container_not_running() {
    echo -e "${BOLD}${DOCKR_NAME} Asset container \"$1\" is ${RED}not running.${CLR}\n"
    echo -e "${BOLD}You can run the ${DOCKR_NAME} asset container${CLR}(s) ${BOLD} using ${CYAN}\"dockr asset up\"${CLR}"

    exit 1
}

# Display DockR Asset Containers are stopped and Terminate.
dockr_asset_container_is_stopped() {
    echo -e "${BOLD}The ${DOCKR_NAME} Asset container \"$1\" is ${RED}stopped.${CLR}\n"
    echo -e "${BOLD}You can start the ${DOCKR_NAME} asset container${CLR}(s) ${BOLD}using ${CYAN}\"dockr asset up\"${CLR}"

    exit 1
}

# Display warning message when asset containers are not set to start.
display_assets_not_set_to_start() {
    echo -e "${RED}Warning :${CLR} Your configurations are ${BOLD}set not to start${CLR} any asset containers.\n"
    echo -e "Please change your configurations, or"
    echo -e "Set ${CYAN}'DOCKR_OVERRIDE_ASSET_CONFIG'${CLR} env variable in your project."

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
