#!/bin/bash

# kubectl create secret generic -n $NS kafka-secret \
# $(for i in `seq 0 1 "$(($NUMBER_OF_BROKERS-1))"`; do echo "--from-file kafka-$i.keystore.pem=./kafka/certs/kafka-broker-$i.cert.pem"; \
# echo "--from-file kafka-$i.keystore.key=./kafka/certs/kafka-broker-$i.key.pem"; done) \
# --from-file "kafka.truststore.pem=./root-ca/certs/ca.cert.pem" \
# --from-literal kafka-zookeper-password=$KAFKA_ZOOKEPER_PASSWORD

# generate password
KAFKA_ZOOKEPER_PASSWORD=$(openssl rand -base64 20)

kubectl create secret generic -n $NS kafka-secret \
--from-file "kafka.truststore.pem=$BASE_CERT_PATH/$root_cert" \
--from-literal kafka-zookeper-password=$KAFKA_ZOOKEPER_PASSWORD \
--from-literal keystore-password=$keystore_password

# producer consumer broker-0 broker-1 zookeeper
# kafka-X.keystore.pem -- id of broker
# kafka-X.keystore.key -- id of broker


for i in `seq 0 1 "$(($NUMBER_OF_BROKERS-1))"`; do

    CERT=$(cat $BASE_CERT_PATH/broker-$i-signed.crt | base64 | tr -d '\n' )
    KEY=$(cat $BASE_CERT_PATH/broker-$i.key | base64 | tr -d '\n')

    kubectl -n $NS patch secret kafka-secret \
    -p="{\"data\":{\"kafka-${i}.keystore.pem\": \"$CERT\"}}"

    kubectl -n $NS patch secret kafka-secret \
    -p="{\"data\":{\"kafka-${i}.keystore.key\": \"$KEY\"}}"
done
