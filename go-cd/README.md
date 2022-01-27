# GO CD chart

## Repo info

Docs [go cd docs](https://docs.gocd.org/current/)

- Chart Version: `1.40.2`

## Installation

```sh
  ### Installing chart ###

  helm repo add gocd https://gocd.github.io/helm-chart
  helm repo update

  helm upgrade --install -n tools gocd gocd/gocd --version 1.40.2 \
    --values go-cd/values.yaml \
    --timeout 600s \
    --set rbac.create=false \
    --set serviceAccount.create=false \
    --set server.service.type=ClusterIP \
    --set server.server.enabled=false \
    --set server.ingress.enabled=false \
    --set agent.replicaCount=2

```

## Configuring route
```sh
  k apply -f go-cd/certificate.yaml
  k apply -f go-cd/gateway.yaml
  k apply -f go-cd/virtual-service.yaml
```