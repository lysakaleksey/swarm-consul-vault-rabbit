#!/usr/bin/env bash

source main.env
source vault.env

eval $(docker-machine env $MANAGER)

# Create infra network if needed
exists=$(docker network ls --format "{{.Name}}" | grep ${NETWORK})
if [[ -z "$exists" ]]; then
    id=$(docker network create --driver=overlay --attachable ${NETWORK})
    echo "Network '${NETWORK}' has been created"
fi

# Deploy consul stack
env NODE1=${NODE1} NODE2=${NODE2} NODE3=${NODE3} \
docker stack deploy -c consul.yml consul

# Deploy vault stack
env NODE1=${NODE1} NODE2=${NODE2} NODE3=${NODE3} VAULT_ADDR=${VAULT_ADDR} \
CONSUL_LOCAL_CONFIG="${CONSUL_LOCAL_CONFIG}" \
VAULT_1_CONFIG=${VAULT_1_CONFIG} \
VAULT_2_CONFIG=${VAULT_2_CONFIG} \
VAULT_3_CONFIG=${VAULT_3_CONFIG} \
CONSUL_ARGS="${CONSUL_ARGS}" \
docker stack deploy -c vault.yml vault

# Deploy rabbit stack
env NODE1=${NODE1} NODE2=${NODE2} NODE3=${NODE3} \
docker stack deploy -c rabbitmq.yml rabbitmq

# Deploy app stack
docker stack deploy -c app.yml app

