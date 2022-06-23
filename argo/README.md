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

  helm -n argo upgrade -i argo-workflows argo/argo-workflows --version 0.16.2
```

### Permissions

```sh
kubectl -n argo create sa argo-workflow-ui
kubectl -n argo create rolebinding argo-ui-rb \
--clusterrole=argo-workflows-admin --serviceaccount=argo:argo-workflow-ui

# kubectl -n argo create role jenkins --verb=list,update --resource=workflows.argoproj.io

# kubectl -n argo create rolebinding jenkins --role=jenkins --serviceaccount=argo:jenkins



SECRET=$(kubectl -n argo get sa argo-workflow-ui -o=jsonpath='{.secrets[0].name}')
ARGO_TOKEN="Bearer $(kubectl -n argo get secret $SECRET -o=jsonpath='{.data.token}' | base64 --decode)"
echo $ARGO_TOKEN
# Use namespace argo
```

### Testing
```sh
k create -f argo/examples/container_template.yaml
k create -f argo/examples/script_template.yaml
k create -f argo/examples/resource_template.yaml
```

### Logs to MiniO
```sh


kubectl -n argo edit cm argo-workflows-workflow-controller-configmap
#Adicionar em .data:
  # artifactRepository: |
  #   archiveLogs: true
  #   s3:
  #     bucket: argo-logs
  #     endpoint: minio.default.svc.cluster.local:9000
  #     insecure: true
  #     accessKeySecret:
  #       name: minio-cred
  #       key: accesskey
  #     secretKeySecret:
  #       name: minio-cred
  #       key: secretkey
  #     createBucketIfNotPresent:
  #       objectLocking: true


kubectl create secret generic -n argo minio-cred \
  --from-literal=accesskey=$MINIO_USER \
  --from-literal=secretkey=$MINIO_PASSWORD
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

  helm upgrade -i --wait argo-cd argo/argo-cd --version 4.8.3
```

