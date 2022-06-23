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

kubectl -n argo create role argo-admin-role --verb=create,delete,deletecollection,get,list,patch,update,watch --resource=pods,workflows,workflows/finalizers,workfloweventbindings,workfloweventbindings/finalizers,workflowtasksets,workflowtasksets/finalizers,workflowtemplates,workflowtemplates/finalizers,cronworkflows,cronworkflows/finalizers,clusterworkflowtemplates,clusterworkflowtemplates/finalizers

kubectl -n argo create rolebinding argo-ui-rb \
--role=argo-admin-role --serviceaccount=argo:argo-workflow-ui



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

argo submit -n argo --watch argo/examples/9-template_dag_with_parameters.yaml \
-p message1="Paramter from terminal"
```

### Logs to MiniO
```sh


kubectl -n argo edit cm argo-workflows-workflow-controller-configmap
#Adicionar em .data:
  config: |
    containerRuntimeExecutor: emissary
    artifactRepository:
      archiveLogs: true
      s3:
        bucket: argo-logs
        endpoint: minio.default.svc.cluster.local:9000
        insecure: true
        accessKeySecret:
          name: minio-cred
          key: accesskey
        secretKeySecret:
          name: minio-cred
          key: secretkey
    workflowDefaults:
      metadata:
        annotations:
          argo: workflows
        labels:
          foo: bar
      spec:
        ttlStrategy:
          secondsAfterSuccess: 3600
        parallelism: 3
        serviceAccountName: "argo-workflow-ui"


kubectl create secret generic -n argo minio-cred \
  --from-literal=accesskey=$MINIO_USER \
  --from-literal=secretkey=$MINIO_PASSWORD

MINIO_USER=$(kubectl get secrets minio -o json | jq '.data | map_values(@base64d)' | jq -r '."root-user"')
MINIO_PASSWORD=$(kubectl get secrets minio -o json | jq '.data | map_values(@base64d)' | jq -r '."root-password"')

echo "user: $MINIO_USER -- password: $MINIO_PASSWORD"


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

