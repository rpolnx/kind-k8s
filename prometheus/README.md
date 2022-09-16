# Prometheus

## Repo info

Chart repository [main page](https://prometheus.io/)

Artifactory [artifacthub](https://artifacthub.io/packages/helm/prometheus-community/prometheus)

- Chart Version: `15.0.1`

# Installation

## Installing prometheus

```sh
  helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
  helm repo update

  NS=default

  helm upgrade --install --version 15.0.1 -n $NS prometheus prometheus-community/prometheus \
  --values  "./values.yaml"
  --set     "server.service.type=LoadBalancer"

```
