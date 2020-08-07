#!/usr/bin/env bash

set -eou pipefail

PORT="6379"

function newNodeAddr() {
    docker container inspect -f \
        '{{index .NetworkSettings.Networks "redis-cluster_default" "IPAddress"}}' \
        "$@"
}

function addNode() {
    local args
    args="--cluster add-node $1 $2"

    [ "$3" = "slave" ] && args+=" --cluster-slave"

    docker-compose exec node redis-cli ${args}
}

function main() {
    # Scale up one node.
    docker-compose up -d --scale node=7

    # Get address of new node.
    local new_node_addr
    local old_node_addr
    new_node_addr=$(newNodeAddr redis-cluster_node_7)
    # Get address of an old node.
    old_node_addr=$(newNodeAddr redis-cluster_node_1)

    # Add new node to cluster. It's role can be either master or slave depends on the last argument.
    addNode "${new_node_addr}:${PORT}" "${old_node_addr}:${PORT}" "$1"

    # Manually reshard if new node is master.
    [ "$1" = "master" ] && docker-compose exec node redis-cli --cluster reshard redis-cluster_node_1:"${PORT}" || exit 0
}

main "$1" || exit 1
