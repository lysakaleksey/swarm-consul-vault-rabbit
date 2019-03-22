# swarm-consul-vault-rabbit

# Open UIs in the browser
Please note `swarm1` is the docker machine node name  

## Consul
`open "http://$(docker-machine ip swarm1):8500"`

## Vault
`open "http://$(docker-machine ip swarm1):8200/ui"`

## HA Proxy UI
`open "http://$(docker-machine ip swarm1):1936"`

## Rabbit MQ UI
Please find user/password in rabbitmq.env
`open "http://$(docker-machine ip swarm1):15672"`