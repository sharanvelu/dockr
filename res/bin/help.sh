#!/bin/bash

## DockR by Sharan

print_list_item() {
    COMMAND=$1
    shift 1

    if [ ${#COMMAND} -lt 8 ]; then
        printf "%s\t\t- %s\n" "${COMMAND}" "$*"
    elif [ ${#COMMAND} -lt 16 ]; then
        printf "%s\t- %s\n" "${COMMAND}" "$*"
    elif [ ${#COMMAND} -lt 24 ]; then
        printf "%s\t - %s\n" "${COMMAND}" "$*"
    fi
}

print_options() {
    if [ ${#2} -lt 16 ]; then
        SECOND_SPACING="\t\t"
    elif [ ${#2} -lt 16 ]; then
        SECOND_SPACING="\t"
    elif [ ${#2} -ge 16 ]; then
        SECOND_SPACING="  "
    fi

    if [ "$1" == "" ]; then
        SHORTHAND_PROP="      "
    else
        SHORTHAND_PROP="  $1, "
    fi
    printf "%s%s$SECOND_SPACING%s\n" "${SHORTHAND_PROP}" "$2" "$3"
}

print_example() {
    printf "\t%s\n" "$@"
}

print_usage() {
    printf "\n%s\t: %s\n\n" "Usage" "$1"
}

print_note() {
    echo -e "\nNote : $@"
}

print_all() {
    if [ "${HELP_TYPE-:null}" == "help" ]; then
        printf "\n%s\n\n" "A Local development environment for Laravel using Docker"
    else
        echo -e "\n${DOCKR_NAME} : Command '${BOLD}$1${CLR}' is not available\n"
    fi

    echo "--- ${DOCKR_NAME} Help ---"
    print_usage "dockr help [COMMAND]"

    print_list_item up Create and Start containers
    print_list_item down Stop the container and remove the container
    print_list_item stop Stop the container without removing it
    print_list_item asset Start or Stop the asset containers
    print_list_item php Execute php commands within the container
    print_list_item composer Execute Composer commands within the container
    print_list_item bin Execute binary \(vendor/bin/\) commands within the container
    print_list_item artisan Run artisan commands
    print_list_item art Run artisan commands. Shorthand for \"artisan\" command
    print_list_item test Run \"php artisan test\" commands within the container
    print_list_item tinker Creates a tinker session
    print_list_item migrate Run migration within the contaner
    print_list_item seed Run seeder within the container
    print_list_item make Run \"php artisan make\" commands within the container
    print_list_item queue Start the queue worker
    print_list_item node Execute node commands
    print_list_item npm Execute npm commands
    print_list_item yarn Execute yarn commands
    print_list_item shell Create a SSH session for the container
    print_list_item bash Create a SSH session for the container
    print_list_item phpunit Run \"vendor/bin/phpunit\" commands within the container
    print_list_item mysql Manage Mysql container
    print_list_item postgres Manage Postgres container
    print_list_item redis Manage Redis container
    print_list_item image Manage images used for ${DOCKR_NAME}
    print_list_item status Display the status of the asset container and the project containers
    print_list_item ps Shorthand property for status command

    echo -e "\nRun '${BOLD}dockr help [COMMAND]${CLR}' for additional information on a command"
}

if [ "$1" == "help" ]; then
    shift 1
fi

if [ $# -gt 0 ]; then
    # Up
    if [ "$1" == "up" ]; then
        print_usage "dockr up [options]"
        echo -e "Create and Start containers\n"
        echo "Options : "
        print_options "-d" "--detach" "Detached mode: Run containers in the background"
#        print_options "" "--detach" "Detached mode: Run containers in the background"

    # Down
    elif [ "$1" == "down" ]; then
        print_usage "dockr down [options]"
        echo -e "Stop and remove the containers\n"
        echo "Options : "
        print_options "" "asset" "Stop and remove the project containers as well as the asset containers."
        print_options "" "all" "Stop and remove all the containers by ${DOCKR_NAME}."
        print_options "" "all -f" "Force remove all the containers by ${DOCKR_NAME} without stopping."
        print_options "-v" "--volumes" "Remove volumes created for Asset containers."

    # Asset
    elif [ "$1" == "asset" ]; then
        print_usage "dockr asset [options]"
        echo -e "Control the asset containers\n"
        echo "Options : "
        print_options "" "up" "Starts the asset containers in detached mode."
        print_options "" "stop" "Stops the asset containers without removing them."
        print_options "" "down" "Stops and remove the asset containers."

    # PHP
    elif [ "$1" == "php" ]; then
        print_usage "dockr php [php_commands]"
        echo -e "Runs PHP commands within web container"

    # Composer
    elif [ "$1" == "composer" ]; then
        print_usage "dockr composer [composer_commands]"
        echo -e "Runs composer commands within web container\n"
        echo "Example : "
        print_example "dockr composer install"
        print_example "dockr composer update"
        print_example "dockr composer require package_name"

    # Bin
    elif [ "$1" == "bin" ]; then
        print_usage "dockr bin [binary_command]"
        echo -e "Run binary (vendor/bin/) commands\n"
        echo "Example : "
        print_example "dockr bin phpunit ..."

    # Artisan / Art
    elif [ "$1" == "artisan" ] || [ "$1" == "art" ]; then
        print_usage "dockr art/artisan [artisan_commands]"
        echo -e "Run php artisan commands\n"
        echo "Example : "
        print_example "dockr art migrate"
        print_example "dockr art tinker"
        print_example "dockr art down"
        print_example "dockr artisan down"

        print_note "'art' is shorthand property for 'artisan'."

    # Test
    elif [ "$1" == "test" ]; then
        print_usage "dockr test [commands]"
        echo -e "Run commands as php artisan test <command> within the container."

    # Tinker
    elif [ "$1" == "tinker" ]; then
        print_usage "dockr tinker"
        echo -e "Starts a tinker CLI session within the container."

        print_note "'dockr tinker' is shorthand property for 'dockr artisan tinker'."

    # Migrate
    elif [ "$1" == "migrate" ]; then
        print_usage "dockr migrate [options]"
        echo -e "Runs the migration inside the container.\n"
        echo "Options : "
        print_options "" "fresh" "Runs 'php artisan migrate:fresh' command"
        print_options "" "rollback" "Runs 'php artisan migrate:rollback' command"
        print_options "" "refresh" "Runs 'php artisan migrate:refresh' command"

        print_note "All default migrate commands will work."

    # Seed
    elif [ "$1" == "seed" ]; then
        print_usage "dockr seed [class](optional)"
        echo -e "Runs the migration inside the container.\n"
        echo "Options : "
        print_options "" "seed ClassName" "Runs 'php artisan db:seed --class=ClassName' command"

        echo ""
        echo "Example : "
        print_example "dockr seed"
        print_example "dockr seed UserSeeder"

    # Make
    elif [ "$1" == "make" ]; then
        print_usage "dockr make [type] [name]"
        echo -e "Runs the 'php artisan make:<type> <name>' command inside the container.\n"

        echo "Example : "
        print_example "dockr make model User"
        print_example "dockr make seeder UserSeeder"
        print_example "dockr make job UserJob"
        print_example "dockr make command UserCommand"

        print_note "All default make commands will work this way."

    # Image
    elif [ "$1" == "image" ]; then
        print_usage "dockr image [option]"
        echo -e "Manage images from ${DOCKR_NAME}\n"
        echo "Options : "
        print_options "" "ls" "Display the list of downloaded ${DOCKR_NAME} images"
        print_options "" "prune" "Destroys every downloaded ${DOCKR_NAME} images"

    # Status
    elif [ "$1" == "status" ]; then
        print_usage "dockr status"
        echo -e "Prints the status of the Asset Containers and the project containers"

    # Status
    elif [ "$1" == "mysql_import" ]; then
        print_usage "dockr mysql import <db_name> <path_to_file.sql>"
        echo -e "Imports the specified <path_to_file.sql> from host machine to the specified <db_name>.\n"
        echo "Example : "
        print_example "dockr mysql import dockr_db /root/dockr/dockr_db_import.sql"

        print_note "Don't use <path_to_file.sql> files with ${YELLOW}blank space \" \"${CLR}. If there is any blank space, please rename the file and try again."

    # Status
    elif [ "$1" == "mysql_query" ]; then
        print_usage "dockr mysql <db_name> -q \"query statement\""
        echo -e "Executes the specified query in specified DB and prints the result.\n"
        echo "Example : "
        print_example "dockr mysql test_db -q \"select * from users\""
        print_example "dockr mysql test_db -q \"create database test_database\""
        print_example "dockr mysql test_database -q \"select * from users\""

        print_note "Watch the ${BOLD}\"double quotes\"${CLR} around the query statement. You Must specify the double quotes(\")."

    # Status
    elif [ "$1" == "postgres_import" ]; then
        print_usage "dockr postgres import <db_name> <path_to_file.sql>"
        echo -e "Imports the specified <path_to_file.sql> from host machine to the specified <db_name>.\n"
        echo "Example : "
        print_example "dockr postgres import dockr_db /root/dockr/dockr_db_import.sql"

        print_note "Don't use <path_to_file.sql> files with ${YELLOW}blank space \" \"${CLR}. If there is any blank space, please rename the file and try again."

    else
        print_all $1
    fi
else
    HELP_TYPE="help"
    print_all
fi

echo ""
