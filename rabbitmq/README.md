# Rabbitmq

## Bitnami Rabbitmq

### Repo info

Chart repository [github](https://github.com/bitnami/containers/tree/main/bitnami/rabbitmq)

Artifactory [artifacthub](https://artifacthub.io/packages/helm/bitnami/rabbitmq)

- Chart Version: ``10.3.5``

### Installation


```sh

NS=tools

RABBITMQ_USER=root
RABBITMQ_PASS=$(openssl rand -base64 20)
ERLANG_COOKIE=$(openssl rand -base64 32)

helm -n $NS upgrade -i rabbitmq bitnami/rabbitmq \
--version 10.3.5 \
--set clustering.enabled=true \
--set replicaCount=2 \
--set image.tag="3.10.7-debian-11-r11" \
--set auth.username=$RABBITMQ_USER     \
--set auth.password="$RABBITMQ_PASS" \
--set auth.erlangCookie="$ERLANG_COOKIE" \
--set "extraPlugins=rabbitmq_shovel rabbitmq_prometheus"


# get pass
kubectl get secret --namespace default rabbitmq -o jsonpath="{.data.rabbitmq-password}" | base64 -d

# get erlang cookie
kubectl get secret --namespace default rabbitmq -o jsonpath="{.data.rabbitmq-erlang-cookie}" | base64 -d
```


## Rabbitmq exporter

### Repo info

Chart repository [github](https://github.com/kbudde/rabbitmq_exporter)

Artifactory [artifacthub](https://artifacthub.io/packages/helm/prometheus-community/prometheus-rabbitmq-exporter)

- Chart Version: ``1.3.0``

### Installation

```sh

NS=tools

helm -n $NS upgrade -i rabbitmq-exporter prometheus-community/prometheus-rabbitmq-exporter \
--version 1.3.0 \
--set "fullnameOverride=rabbitmq-exporter" \
--set "rabbitmq.url=http://rabbitmq-headless.$NS.svc.cluster.local:15672" \
--set "rabbitmq.user=$RABBITMQ_USER" \
--set "rabbitmq.existingPasswordSecret=rabbitmq" \
--set "rabbitmq.existingPasswordSecretKey=rabbitmq-password" \
--set "prometheus.monitor.enabled=true" \
--set "prometheus.monitor.additionalLabels.release=prometheus-stack" \
--set "prometheus.monitor.interval=1s"

k port-forward svc/rabbitmq-exporter 8080:9419

curl -XGET http://127.0.0.1:8080/metrics
```

