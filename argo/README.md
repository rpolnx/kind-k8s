# Argo

## Argo Workflow

### Repo info

Chart repository [github](https://github.com/argoproj/argo-workflows)

Artifactory [artifacthub](https://artifacthub.io/packages/helm/argo/argo-workflows)

- Chart Version: ``0.16.2``

### Installation

```sh
  ### Secrets and configs ###

  ### Installing chart ###

  helm repo add argo https://argoproj.github.io/argo-helm

  helm install argo-workflows argo/argo-workflows --version 0.16.2
```

## Argo CD

### Repo info

Chart repository [github](https://github.com/argoproj/argo-cd)

Artifactory [artifacthub](https://artifacthub.io/packages/helm/argo/argo-cd)

- Chart Version: ``4.8.3``

### Installation

```sh
  ### Secrets and configs ###

  ### Installing chart ###

  helm repo add argo https://argoproj.github.io/argo-helm

  helm install argo-cd argo/argo-cd --version 4.8.3
```