#!/usr/bin/env bash

source main.env

eval $(docker-machine env $MANAGER)

docker stack rm app
docker stack rm rabbitmq
docker stack rm vault
docker stack rm consul

docker network remove ${NETWORK}
