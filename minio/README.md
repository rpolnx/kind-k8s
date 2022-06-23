# Minio

## Argo Workflow

### Repo info

Docs [minio](https://min.io/)

Chart repository [github](https://github.com/bitnami/bitnami-docker-minio)

Artifactory [artifacthub](https://artifacthub.io/packages/helm/bitnami/minio)

- Chart Version: ``11.7.6``

### Installation

```sh
  ### Secrets and configs ###

  ### Installing chart ###

  helm repo add bitnami https://charts.bitnami.com/bitnami

  helm upgrade -i minio bitnami/minio --version 11.7.6
```

### Testing
```sh

MINIO_USER=$(kubectl get secrets minio -o json | jq '.data | map_values(@base64d)' | jq -r '."root-user"')
MINIO_PASSWORD=$(kubectl get secrets minio -o json | jq '.data | map_values(@base64d)' | jq -r '."root-password"')

echo "user: $MINIO_USER -- password: $MINIO_PASSWORD"

kubectl port-forward --namespace default svc/minio 9001:9001

```
