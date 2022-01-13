# Sonar Qube from Oteemo

## Repo info

Docs [Gitlab docs](https://docs.gitlab.com/charts/quickstart/index.html)

- Chart Version: `5.6.2`

## Installation

```sh
  ### Installing redis chart ###

  helm repo add gitlab https://charts.gitlab.io/

  helm repo update

  helm install -n tools gitlab gitlab/gitlab --version 5.6.2 \
    --values gitlab/values.yaml \
    --timeout 600s \
    --set global.hosts.https=false \
    --set global.ingress.configureCertmanager=false \
    --set global.ingress.enabled=false \
    --set nginx-ingress.enabled=false \
    --set certmanager.enabled=false \
    --set certmanager.install=false \
    --set global.edition=ce \
    --set global.hosts.domain=gitlab-pvt.rpolnx.com.br \
    --set certmanager-issuer.email=rodrigorpogo@gmail.com
    # --set global.hosts.externalIP=10.10.10.10 \

```