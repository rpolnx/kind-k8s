# How to run kafka from cli

## PRD

### Connect on environment vpn

```sh
./kafka_2.13-3.0.0/bin/kafka-console-consumer.sh \
--bootstrap-server kafka.tools.svc.cluster.local:9092 --consumer.config prd/config.properties --from-beginning --topic products

./kafka_2.13-3.0.0/bin/kafka-topics.sh --bootstrap-server kafka.tools.svc.cluster.local:9092 --command-config prd/config.properties \
--list
```

### Kafka drop
```sh
    helm upgrade -n tools -i kafdrop kafka-drop/chart \
        --set kafka.brokerConnect=kafka.tools.svc.cluster.local:9092 \
        --set kafka.properties="$(cat prd/config-kafkadrop.properties | base64)" \
        --set kafka.truststore="$(cat prd/truststore.jks | base64)"
```

## HML

### Run on environment
```sh
./kafka_2.13-3.0.0/bin/kafka-console-consumer.sh \
--bootstrap-server kafka.tools.svc.cluster.local:9092 --consumer.config hml/config.properties --from-beginning --topic products
```

### Kafka drop
```sh
    helm upgrade -n tools -i kafdrop kafka-drop/chart \
        --set kafka.brokerConnect=kafka.tools.svc.cluster.local:9092 \
        --set kafka.properties="$(cat config-kafkadrop-hml.properties | base64)" \
        --set kafka.truststore="$(cat hml/truststore.jks | base64)"
```