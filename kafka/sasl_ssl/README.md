# Bitnami kafka

## Repo info

Chart repository [github](https://github.com/bitnami/charts/tree/master/bitnami/kafka)

Artifactory [artifacthub](https://artifacthub.io/packages/helm/bitnami/kafka)

- Chart Version: `14.6.0`

# Installation

## Initialize variables

```sh
  export NUMBER_OF_BROKERS=3
  export NS=default
  export SECRET_NAME=kafka-secret
  export ZOOKEEPER_USER=zkp_user
  export ZOOKEEPER_PASSWORD=$(openssl rand -base64 20)
```

## Initialize variables

```sh
  kubectl -n $NS create secret generic $SECRET_NAME --from-literal=zookeeper-password=$ZOOKEEPER_PASSWORD
```

## Installing kafka chart

```sh
  helm repo add bitnami https://charts.bitnami.com/bitnami

  helm upgrade --install --version 14.6.0 -n $NS kafka-cluster bitnami/kafka \
  --values  "./values.yaml" \
  --set     "heapOpts=-Xmx1024m -Xms1024m" \
  --set     "auth.clientProtocol=plaintext" \
  --set     "auth.interBrokerProtocol=plaintext" \
  --set     "replicaCount=$NUMBER_OF_BROKERS" \
  --set     "externalAccess.enabled=false" \
  --set     "externalAccess.autoDiscovery.enabled=true" \
  --set     "externalAccess.service.port=9094" \
  --set     "externalAccess.service.type=LoadBalancer" \
  --set     "serviceAccount.create=true" \
  --set     "rbac.create=true" \
  --set     "persistence.size=3Gi" \
  --set     "provisioning.enabled=true" \
  --set     "provisioning.numPartitions=5" \
  --set     "provisioning.replicationFactor=$NUMBER_OF_BROKERS" \
  --set     "deleteTopicEnable=true" \
  --set     "zookeeper.auth.enabled=true" \
  --set     "zookeeper.auth.clientUser=$ZOOKEEPER_USER" \
  --set     "zookeeper.auth.clientPassword=$ZOOKEEPER_PASSWORD" \
  --set     "zookeeper.auth.serverUsers=$ZOOKEEPER_USER" \
  --set     "zookeeper.auth.serverPasswords=$ZOOKEEPER_PASSWORD" \
  --set     "auth.jaas.zookeeperUser=$ZOOKEEPER_USER" \
  --set     "auth.jaas.zookeeperPassword=$ZOOKEEPER_PASSWORD" \
  --set     "zookeeper.replicaCount=$NUMBER_OF_BROKERS" \
  --set     "metrics.kafka.enabled=true" \
  --set     "metrics.jmx.enabled=true"

```

# Testing

## Kafka drop
```sh
    helm upgrade -n $NS -i kafdrop kafka-drop/chart \
        --set kafka.brokerConnect=kafka-cluster-headless.default.svc.cluster.local:9092 \
        --set service.type=LoadBalancer
```


## Monitoring

# https://www.metricfire.com/blog/kafka-monitoring-using-prometheus/