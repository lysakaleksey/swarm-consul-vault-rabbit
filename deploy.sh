#!/usr/bin/env bash

source main.env

# Create main network if needed
exists=$(docker network ls --format "{{.Name}}" | grep ${NETWORK})
if [[ -z "$exists" ]]; then
    id=$(docker network create --driver=overlay --attachable ${NETWORK})
    echo "Network '${NETWORK}' has been created"
fi

# Deploy consul stack
env NODE1=${NODE1} NODE2=${NODE2} NODE3=${NODE3} docker stack deploy -c consul.yml consul

# Deploy rabbit stack
env NODE1=${NODE1} NODE2=${NODE2} NODE3=${NODE3} docker stack deploy -c rabbitmq.yml rabbitmq

# Deploy vault stack
env NODE1=${NODE1} NODE2=${NODE2} NODE3=${NODE3} docker stack deploy -c vault.yml vault

