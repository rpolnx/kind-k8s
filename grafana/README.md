# Grafana

## Repo info

Chart repository [main page](https://prometheus.io/)

Artifactory [artifacthub](https://artifacthub.io/packages/helm/prometheus-community/prometheus)

- Chart Version: `6.19.2`

# Installation

## Initialize variables

```sh
  export NS=default
  
  export SECRET_NAME=grafana-credentials
  export GRAFANA_USER=admin
  export GRAFANA_PASSWORD=$(openssl rand -base64 20)
```

## Initialize variables

```sh
  kubectl -n $NS create secret generic $SECRET_NAME \
    --from-literal=admin-user=$GRAFANA_USER \
    --from-literal=admin-password=$GRAFANA_PASSWORD
```

## Installing prometheus

```sh
  helm repo add grafana https://grafana.github.io/helm-charts
  helm repo update

  helm upgrade --install --version 6.19.2 -n $NS grafana grafana/grafana \
  --values  "./values.yaml" \
  --set     "service.type=LoadBalancer" \
  --set     "admin.existingSecret=$SECRET_NAME"

```
