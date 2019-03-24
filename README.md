# Swarm Consul Rabbit

## 1. Prerequisites
* docker
* docker-machine
* 

## 2. Build custom images
Please edit **build.sh** in order to use your container repository.
New repository has to be set in **rabbitmq.yml** and **app.yml**

## 3. Edit environments
Please find these environment variables in the root folder:

* main.env - Please edit `NODE1, NODE2, NODE1, MANAGER` variables to match your swarm cluster configuration.
* vault.env - vault stack. You do not need to change anything there.
* consul.env - consul stack. You do not need to change anything there.
* rabbitmq.env - rabbitmq stack. You might want to change default user name and password. If you change them, please make sure `AMQP_URL` (see app.yml) is also updated.  

## 4. Deploy stacks
Please use `deploy.sh` to deploy all stacks. No arguments needed.

Once all stacks are deployed and up, you might want to initialize `vault`

To do that, please use `vault-init.sh`. No arguments needed

### 5. Open UIs in the browser
Please note `swarm1` is the docker machine node name for the below UIs:

#### 5.1. Consul
`open "http://$(docker-machine ip swarm1):8500"`

#### 5.2 Vault
`open "http://$(docker-machine ip swarm1):8200/ui"`

#### 5.3. HA Proxy UI
`open "http://$(docker-machine ip swarm1):1936"`

#### 5.4. Rabbit MQ UI
Please find user/password in rabbitmq.env
`open "http://$(docker-machine ip swarm1):15672"`

### 6. Rabbit MQ test app
Please see **app.yml** descriptor for test application. The application exposes two GET endpoints on 8080 port on each node:
* `/` will print `I am alive` in the browser page
* `/send` will send dummy message into 'hello' queue.

See `testapp` folder for the test app source code 

### 7. Un-deploy stack
Please use `undeploy.sh` script in order to un deploy stacks. No arguments needed but it uses `main.env` 