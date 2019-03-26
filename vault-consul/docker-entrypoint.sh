#!/bin/sh

# Start consul in background
export CONSUL_BIND_INTERFACE=eth0
consul-entrypoint.sh $CONSUL_ARGS > /tmp/consul-entrypoint.log &

# Start vault in background
vault-entrypoint.sh server > /tmp/vault-entrypoint.log &

# Main
tail -f /dev/null