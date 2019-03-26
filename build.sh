#!/usr/bin/env bash

docker image build --no-cache -t lysakaleksey/rabbitmq:3.7-management-alpine ./rabbitmq
docker push lysakaleksey/rabbitmq:3.7-management-alpine

docker image build --no-cache -t lysakaleksey/haproxy-for-rabbitmq:1.9-alpine ./haproxy
docker push lysakaleksey/haproxy-for-rabbitmq:1.9-alpine

docker image build --no-cache -t lysakaleksey/rabbitmq-app:latest ./testapp
docker push lysakaleksey/rabbitmq-app:latest

docker image build --no-cache -t lysakaleksey/vault-consul:latest ./vault-consul
docker push lysakaleksey/vault-consul:latest
