#!/usr/bin/env bash

set -eou pipefail

PORT="7000"

function newNodeAddr() {
    docker container inspect -f \
        '{{index .NetworkSettings.Networks "redis-cluster_default" "IPAddress"}}' \
        "$@"
}

function addNode() {
    docker-compose exec node redis-cli --cluster add-node "$1" "$2"
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

    # Add new node to cluster
    addNode "${new_node_addr}:${PORT}" "${old_node_addr}:${PORT}"

    # Manually reshard.
    docker-compose exec node redis-cli --cluster reshard redis-cluster_node_1:7000
}

main || exit 1
