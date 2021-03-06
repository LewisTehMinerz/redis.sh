#!/bin/bash

# Colours
RESET="\033[0m"
PREFIX="\033[0;1;33m$0${RESET}"
HELP_CMD="\033[0;36m"
HELP_CMD_DESCRIPTION="\033[0;1;35m"
START="\033[0;1;32m"
STOP="\033[0;1;31m"
ERROR="\033[0;31m"
# End Colours

redis_help() {
        echo -e "\033[0;1;34mRedis.sh${RESET}"
        echo -e "${PREFIX} ${HELP_CMD}start${RESET}    ${HELP_CMD_DESCRIPTION}Starts the Redis instance."
        echo -e "${PREFIX} ${HELP_CMD}stop${RESET}     ${HELP_CMD_DESCRIPTION}Stops the Redis instance."
        echo -e "${PREFIX} ${HELP_CMD}restart${RESET}  ${HELP_CMD_DESCRIPTION}Restarts the Redis instance."
        echo -e "${PREFIX} ${HELP_CMD}status${RESET}   ${HELP_CMD_DESCRIPTION}Check if Redis is running."
        echo -e "${PREFIX} ${HELP_CMD}config${RESET}   ${HELP_CMD_DESCRIPTION}Edit the Redis configuration."
        echo -e "${PREFIX} ${HELP_CMD}help${RESET}     ${HELP_CMD_DESCRIPTION}See this help message."
}

redis_status() {
        if (pgrep -x "redis-server" > /dev/null) then
                return 0
        else
                return 1
        fi
}

redis_start() {
        if ! redis_status; then
                echo -e "${START}Starting Redis...${RESET}"
                service redis start
        else
                echo -e "${ERROR}Cannot start Redis: It is already running.${RESET}"
        fi
}

redis_stop() {
        if redis_status; then
                echo -e "${STOP}Stopping Redis...${RESET}"
                service redis stop
        else
                echo -e "${ERROR}Cannot stop Redis: It is not running.${RESET}"
        fi
}

redis_config() {
        sudo ${VISUAL:-${EDITOR:-vi}} /etc/redis/redis.conf
}

if [ "$1" == "" ]; then
        redis_help
else
        case $1 in
                start   ) redis_start
                          ;;
                stop    ) redis_stop
                          ;;
                restart ) redis_stop
                          sleep 1
                          redis_start
                          ;;
                status  ) if redis_status; then
                                echo -e "${START}Redis is running.${RESET}"
                          else
                                echo -e "${STOP}Redis is NOT running.${RESET}"
                          fi
                          ;;
                config  ) redis_config
                          ;;
                help | *) redis_help
                          ;;
        esac
fi
