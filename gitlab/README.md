# Gitlab

## Repo info

Docs [Gitlab docs](https://docs.gitlab.com/charts/quickstart/index.html)

- Chart Version: `5.6.2`

## Installation

```sh
  ### Installing redis chart ###

  helm repo add gitlab https://charts.gitlab.io/

  helm repo update

  helm upgrade --debug --install gitlab gitlab/gitlab \
    --timeout 600s \
    --set global.hosts.domain=rpolnx.local \
    --set global.hosts.https=true \
    --set global.ingress.configureCertmanager=false \
    --set global.ingress.enabled=false \
    --set global.ingress.tls.enabled=false \
    --set global.ingress.configureCertmanager=false \
    --set global.ingress.tls.secretName=gitlab-cert \
    --set nginx-ingress.enabled=false \
    --set prometheus.install=false \
    --set certmanager.install=false \
    --set global.edition=ce \
    --set gitlab-runner.install=false
        # --values gitlab/values.yaml \
   
   
      
    # --set gitlab-runner.gitlabUrl=rpolnx.local \
    # --set gitlab-runner.runners.privileged=true \
    # --set global.ingress.annotations."cert-manager\.io/issuer"=ca-issuer \
    # --set global.hosts.externalIP=10.10.10.10 \
    # --set certmanager-issuer.email=rodrigorpogo@gmail.com \

```

## Configuring route
```sh
  k apply -f gitlab/certificate.yaml
  # configure domains
  # gitlab.rpolnx.local
  # pages.rpolnx.local
  # ...

```

## Installing & Configuring runner

```sh
  # edit all CI_SERVER_URL envs to your ci url

kubectl create secret generic gitlab-runner-cert \
  --from-file="gitlab.rpolnx.local.crt=gitlab/gitlab-chain.pem"

helm install gitlab-runner gitlab/gitlab-runner \
  --set gitlabUrl="https://gitlab.rpolnx.local" \
  --set runnerRegistrationToken="$(kubectl get secret gitlab-gitlab-runner-secret -o jsonpath='{.data.runner-registration-token}' |  base64 --decode ; echo)" \
  --set certsSecretName="gitlab-runner-cert"

```
