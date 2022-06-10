# Bitnami Consul

## Repo info

Chart repository [github](https://github.com/hashicorp/consul)

Artifactory [artifacthub](https://artifacthub.io/packages/helm/bitnami/consul)

- Chart Version: ``10.5.2``

## Installation

```sh
  ### Secrets and configs ###

  ### Installing chart ###

  helm repo add bitnami https://charts.bitnami.com/bitnami  

  helm upgrade -i --wait consul bitnami/consul --version 10.5.2 \
  --set replicaCount=1

```
