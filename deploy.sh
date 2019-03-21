#!/usr/bin/env bash

# Create main network if needed
NETWORK_NAME=infra
exists=$(docker network ls --format "{{.Name}}" | grep ${NETWORK_NAME})
if [[ -z "$exists" ]]; then
    id=$(docker network create --driver=overlay --attachable ${NETWORK_NAME})
    echo "Network '${NETWORK_NAME}' has been created"
fi

# Deploy consul stack
docker stack deploy -c consul.yml consul

# Deploy vault stack
docker stack deploy -c vault.yml vault

# Deploy rabbit stack
#docker stack deploy -c rabbitmq.yml rabbit
