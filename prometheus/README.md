# Prometheus

## Repo info

Chart repository [main page](https://prometheus.io/)

Artifactory [artifacthub](https://artifacthub.io/packages/helm/prometheus-community/prometheus)

- Chart Version: `15.0.1`

# Installation

## Initialize variables

```sh
  export NS=default
  export SECRET_NAME=kafka-secret

  export ZOOKEEPER_USER=zkp_user
  export ZOOKEEPER_PASSWORD=$(openssl rand -base64 20)
```

## Initialize variables

```sh
  kubectl -n $NS create secret generic $SECRET_NAME --from-literal=zookeeper-password=$ZOOKEEPER_PASSWORD
```

## Installing prometheus

```sh
  helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
  helm repo update

  helm upgrade --install --version 15.0.1 -n $NS prometheus prometheus-community/prometheus \
  --values  "./values.yaml"
  --set     "server.service.type=LoadBalancer"

```
