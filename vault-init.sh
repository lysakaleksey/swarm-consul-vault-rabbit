#!/usr/bin/env bash

source main.env

echo ""
echo "Initializing vault"
vault operator init > vault-init.keys

echo ""
echo "Unlocking vault by using 3 keys"
vault operator unseal "$(sed -n 1p < vault-init.keys | awk '{print $4}')"
vault operator unseal "$(sed -n 2p < vault-init.keys | awk '{print $4}')"
vault operator unseal "$(sed -n 3p < vault-init.keys | awk '{print $4}')"

echo ""
echo "Vault login using root token"
vault login "$(sed -n 7p < vault-init.keys | awk '{print $4}')"

echo ""
echo "Setup initial secrets"
vault write secret/${SECRET_NAME} @secrets.json

echo ""
echo "Trying to read secrets we just loaded"
vault read --format=json secret/${SECRET_NAME}

echo "Done!"

echo "Login to ui and check. Make sure you copied vault-init.keys!"