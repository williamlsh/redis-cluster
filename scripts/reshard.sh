#!/usr/bin/env bash

function getMasterID() {
    docker-compose exec node redis-cli -p 7000 cluster nodes | grep -m 1 master | awk '{print $1;}' | tr -d '[:space:]'
}

docker-compose exec node redis-cli --cluster reshard redis-cluster_node_1:7000 \
    --cluster-from all \
    --cluster-to "$(getMasterID)" \
    --cluster-slots 1000 \
    --cluster-yes
