#!/usr/bin/env bash

source main.env
source rabbitmq.env

RABBITMQ_HOST="$(docker-machine ip $NODE1)"

curl -X POST -u "$RABBITMQ_DEFAULT_USER:$RABBITMQ_DEFAULT_PASS" -H "Content-Type: application/json" \
http://${RABBITMQ_HOST}:15672/api/definitions -d "@rabbitmq-init.json"