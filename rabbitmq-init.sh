#!/usr/bin/env bash

source main.env
source rabbitmq.env

RABBITMQ_HOST="$(docker-machine ip $NODE1)"

HA_POLICY=`cat<<EOF
{
    "pattern": "^ha\\.",
    "definition": {
        "ha-mode": "all",
        "expires": 1800000
    },
    "priority": 1,
    "apply-to": "queues"
}
EOF`

curl -s -X PUT -u "$RABBITMQ_DEFAULT_USER:$RABBITMQ_DEFAULT_PASS" -H "Content-Type: application/json" \
  http://${RABBITMQ_HOST}:15672/api/policies/%2f/ha-all -d "${HA_POLICY}"

##
#python rabbitmqadmin -H $RABBITMQ_HOST -u $RABBITMQ_DEFAULT_USER -p $RABBITMQ_DEFAULT_PASS list exchanges
#
## Remove
#
#python rabbitmqadmin -H $RABBITMQ_HOST -u $RABBITMQ_DEFAULT_USER -p $RABBITMQ_DEFAULT_PASS \
#declare queue name="notifications" 'arguments={"x-dead-letter-exchange": "mishaps"}'
#
##rabbitmqadmin declare binding source="events" destination="notifications" routing_key="notifications.v1" destination_type="queue"
#
#rabbitmqadmin declare queue name=uid-440099 durable=true auto-delete=false \
#     'arguments={"x-message-ttl":86400000,"x-expires":86400000,"x-dead-letter-exchange":"deadletters.fanout"}'