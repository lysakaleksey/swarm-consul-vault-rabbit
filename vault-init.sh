#!/usr/bin/env bash

export VAULT_ADDR=http://192.168.99.120:8200

vault operator init > vault-init.keys

vault login s.jBdjb7PZzYaMeVkpZuBGhlN5

vault write secret/test @secrets.json