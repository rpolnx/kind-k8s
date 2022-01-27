# Sonar Qube from Oteemo

## Repo info

Docs [Gitlab docs](https://docs.gitlab.com/charts/quickstart/index.html)

- Chart Version: `5.6.2`

## Installation

```sh
  ### Installing redis chart ###

  helm repo add gitlab https://charts.gitlab.io/

  helm repo update

  helm upgrade --install -n tools gitlab gitlab/gitlab --version 5.6.2 \
    --values gitlab/values.yaml \
    --timeout 600s \
    --set global.hosts.domain=gitlab-pvt.rpolnx.com.br \
    --set global.hosts.https=true \
    --set global.ingress.configureCertmanager=false \
    --set global.ingress.enabled=true \
    --set global.ingress.tls.enabled=true \
    --set global.ingress.configureCertmanager=false \
    --set global.ingress.tls.secretName=gitlab-cert \
    --set nginx-ingress.enabled=true \
    --set prometheus.install=false \
    --set certmanager.install=false \
    --set global.edition=ce \
    --set gitlab-runner.install=false
   
   
      
    # --set gitlab-runner.gitlabUrl=gitlab-pvt.rpolnx.com.br \
    # --set gitlab-runner.runners.privileged=true \
    # --set global.ingress.annotations."cert-manager\.io/issuer"=ca-issuer \
    # --set global.hosts.externalIP=10.10.10.10 \
    # --set certmanager-issuer.email=rodrigorpogo@gmail.com \

```

## Configuring route
```sh
  k apply -f gitlab/certificate.yaml
  # configure domains
  # gitlab.gitlab-pvt.rpolnx.com.br
  # pages.gitlab-pvt.rpolnx.com.br
  # ...

```

## Configuring runner

```sh
  # edit all CI_SERVER_URL envs to your ci url
  k -n tools edit deploy gitlab-gitlab-runner

```
