#!/usr/bin/env bash

source main.env

# Vault address. Use first swarm node for now
export VAULT_ADDR="http://$(docker-machine ip $NODE1):8200"

echo ""
echo "Initializing vault"
vault operator init > vault-init.keys

unseal-server() {
    export VAULT_ADDR="$1"
    echo ""
    echo "Unlocking vault by using 3 keys"
    vault operator unseal "$(sed -n 1p vault-init.keys | awk '{print $4}')"
    vault operator unseal "$(sed -n 2p vault-init.keys | awk '{print $4}')"
    vault operator unseal "$(sed -n 3p vault-init.keys | awk '{print $4}')"
}

unseal-server "http://$(docker-machine ip $NODE1):8200"
unseal-server "http://$(docker-machine ip $NODE2):8201"
unseal-server "http://$(docker-machine ip $NODE3):8202"

# Vault address. Use first swarm node for now
export VAULT_ADDR="http://$(docker-machine ip $NODE1):8200"

echo ""
echo "Vault login using root token"
token=$(sed -n 7p vault-init.keys | awk '{print $4}')
vault login "$token"

echo ""
echo "Setup initial secrets"
vault write secret/${SECRET_NAME} @secrets.json

echo ""
echo "Trying to read secrets we just loaded"
vault read --format=json secret/${SECRET_NAME}

echo "Done!"

echo "Login to UI $VAULT_ADDR/ui using token: $token"