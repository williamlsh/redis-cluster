#!/usr/bin/env bash

set -ex

PORT="6379"
ADDRS=""

function containersAddrs() {
    stdbuf -oL docker network inspect redis-cluster_default -f \
        '{{range $element := .Containers}}
            {{$element.IPv4Address}}
        {{end}}'
}

while IFS= read -r line; do
    if [ ! -z "${line// /}" ]; then
        addr="$(echo -e "${line}" | tr -d '[:space:]' | rev | cut -c 4- | rev):${PORT}"
        [ -z "${ADDRS}" ] && ADDRS+="${addr}" || ADDRS+=" ${addr}"
    fi
done <<<"$(containersAddrs)"

docker exec -it redis-cluster-node-1 redis-cli \
    --cluster create \
    ${ADDRS} \
    --cluster-replicas 1
