#!/bin/bash

# generate password
KAFKA_ZOOKEPER_PASSWORD=$(openssl rand -base64 20)

kubectl create secret generic -n $NS kafka-secret \
--from-file "kafka.truststore.jks=$BASE_CERT_PATH/truststore.jks" \
--from-file "kafka.keystore.jks=$BASE_CERT_PATH/zookeeper.keystore.jks" \
--from-literal kafka-zookeper-password=$KAFKA_ZOOKEPER_PASSWORD \
--from-literal keystore-password=$keystore_password \
--from-literal truststore-password=$truststore_password


for i in `seq 0 1 "$(($NUMBER_OF_BROKERS-1))"`; do
    KEYSTORE=$(cat $BASE_CERT_PATH/broker-$i.keystore.jks | base64 | tr -d '\n' )

    kubectl -n $NS patch secret kafka-secret \
    -p="{\"data\":{\"kafka-${i}.keystore.jks\": \"$KEYSTORE\"}}"
done
