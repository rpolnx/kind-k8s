# Bitnami kafka

## Repo info

Chart repository [github](https://github.com/bitnami/charts/tree/master/bitnami/kafka)

Artifactory [artifacthub](https://artifacthub.io/packages/helm/bitnami/kafka)

- Chart Version: `14.4.3`

# Installation

## Initialize variables

```sh
  export NUMBER_OF_BROKERS=3
  export NS=tools
  export SECRET_NAME=kafka-secret
  export ZOOKEEPER_PASSWORD=$(openssl rand -base64 20)
```

## Initialize variables

```sh
  kubectl -n $NS create secret generic $SECRET_NAME --from-literal=zookeeper-password=$ZOOKEEPER_PASSWORD
```

## Installing kafka chart

```sh
  helm repo add bitnami https://charts.bitnami.com/bitnami

  helm upgrade --install --version 14.4.3 -n $NS kafka-cluster bitnami/kafka \
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
  --set     "auth.jaas.zookeeperUser=zookeeperUser" \
  --set     "auth.jaas.zookeeperPassword=$(k get -n $NS secret $SECRET_NAME -o=jsonpath='{.data.zookeeper-password}' | base64 -d)" \
  --set     "zookeeper.auth.enabled=true" \
  --set     "zookeeper.auth.clientUser=zookeeperUser" \
  --set     "zookeeper.auth.clientPassword=$(k get -n $NS secret $SECRET_NAME -o=jsonpath='{.data.zookeeper-password}' | base64 -d)" \
  --set     "zookeeper.auth.serverUsers=zookeeperUser" \
  --set     "zookeeper.auth.serverPasswords=$(k get -n $NS secret kafka-secret -o=jsonpath='{.data.zookeeper-password}' | base64 -d)" \
  --set     "zookeeper.replicaCount=$NUMBER_OF_BROKERS" \
  --set     "metrics.kafka.enabled=true" \
  --set     "metrics.jmx.enabled=true"

```

# Testing

## Kafka drop
```sh
    helm upgrade -n tools -i kafdrop kafka-drop/chart \
        --set kafka.brokerConnect=kafka-cluster-headless.tools.svc.cluster.local:9092
```


## Monitoring

# https://www.metricfire.com/blog/kafka-monitoring-using-prometheus/