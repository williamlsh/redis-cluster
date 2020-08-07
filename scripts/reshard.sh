#!/usr/bin/env bash

PORT="6379"

function getMasterID() {
    docker-compose exec node redis-cli cluster nodes | grep -m 1 master | awk '{print $1;}' | tr -d '[:space:]'
}

docker-compose exec node redis-cli --cluster reshard redis-cluster_node_1:"${PORT}" \
    --cluster-from all \
    --cluster-to "$(getMasterID)" \
    --cluster-slots 1000 \
    --cluster-yes
