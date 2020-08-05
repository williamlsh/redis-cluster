#!/usr/bin/env bash

PORT="7000"
ADDRS=""

function containersAddrs() {
    stdbuf -oL docker network inspect redis-cluster_default -f \
        '{{range $index, $element := .Containers}}
            {{with $x := $element.IPv4Address}}
                {{slice $x 0 13}}
            {{end}}
        {{end}}'
}

while IFS= read -r line; do
    if [ ! -z "${line// /}" ]; then
        if [ -z "${ADDRS}" ]; then
            ADDRS+="$(echo -e "${line}" | tr -d '[:space:]'):${PORT}"
        else
            ADDRS+=" $(echo -e "${line}" | tr -d '[:space:]'):${PORT}"
        fi
    fi
done <<<"$(containersAddrs)"

docker exec -it redis-cluster_node_1 redis-cli \
    --cluster create \
    ${ADDRS} \
    --cluster-replicas 1
