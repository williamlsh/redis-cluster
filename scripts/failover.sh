#!/usr/bin/env bash

function redisCli() {
    docker-compose exec node redis-cli -c -p 7000 "$@"
}

function terminateMaster() {
    redisCli DEBUG SEGFAULT >/dev/null 2>&1
    sleep 10
    docker-compose start node
}

function main() {
    local role
    role=$(redisCli role)
    echo "${role}"

    read -r line <<<"${role}"

    case "${line}" in
    *"master"*)
        echo "Failover by terminating master"
        terminateMaster
        ;;
    *"slave"*)
        echo "Manual failover to slave"
        redisCli CLUSTER FAILOVER >/dev/null 2>&1
        ;;
    *)
        echo "Unkonwn role"
        exit 1
        ;;
    esac
}

main || exit 1
