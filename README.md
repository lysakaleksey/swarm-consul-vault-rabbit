# Swarm Consul Rabbit

## 1. Prerequisites
* docker v18.09.2+
* docker-machine v0.16.1
* vault v1.0.3 (required to init only) 
* internet access

## 2. Build custom images
Please edit **build.sh** in order to use your container repository.

Your repository has to be set in **rabbitmq.yml** and **app.yml** files too.

## 3. Edit environments
Please find these environment variables in the root folder:

* main.env - Please edit `NODE1, NODE2, NODE1, MANAGER` variables to match your swarm cluster configuration.
* vault.env - vault stack. You do not need to change anything there.
* consul.env - consul stack. You do not need to change anything there.
* rabbitmq.env - rabbitmq stack. You might want to change default user name and password. If you change them, please make sure to change them in `app.yml` too.  

## 4. Deploy stacks & post-deploy initialize
Use `deploy.sh` to deploy all stacks. No arguments needed.

Once all stacks are deployed, up & running, you need to initialize rabbitmq and vault.

### 4.1 RabbitMQ initialization

Please edit `rabbitmq-init.json` in order to setup queue/dead letter exchange/exchange bindings/dead letter queue.

The mapping looks like: `Queue -> Exchange -> Binding -> Dead Letter Queue` 

After editing `rabbitmq-init.json`, please run `rabbitmq-init.sh`. No arguments needed. It is safe to re-execute the script as many as needed. 

### 4.2 Vault initialization
Please edit (optionally) `secrets.json` to put default secret key-value pairs which will be initially load into vault.

To initialize `vault`, please use `vault-init.sh`. No arguments needed.

## 5. Open UIs in the browser
Please note `swarm1` is the docker machine node name for the below UIs:

### 5.1. Consul
`open "http://$(docker-machine ip swarm1):8500"`

### 5.2 Vault
`open "http://$(docker-machine ip swarm1):8200/ui"`

### 5.3. HA Proxy UI
`open "http://$(docker-machine ip swarm1):1936"`

### 5.4. Rabbit MQ UI
Please find user/password in rabbitmq.env
`open "http://$(docker-machine ip swarm1):15672"`

## 6. Rabbit MQ test app
Please see **app.yml** descriptor for test application. The application exposes the following endpoints on 8080 port on each node:
* `/` will print `I am alive` in the browser page
* `/send` will send dummy message into queue.
* `/get` will read the message from the queue and print on the page or `No data found` if no messages in the queue.

See `testapp` folder for the test app source code 

## 7. Un-deploy stacks
Please use `undeploy.sh` script in order to un-deploy everything. No arguments needed. 