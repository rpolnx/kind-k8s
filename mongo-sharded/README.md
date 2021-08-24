# Bitnami mongo

## Repo info

Chart repository [github](https://artifacthub.io/packages/helm/bitnami/mongodb-sharded)

Artifactory [artifacthub](https://github.com/bitnami/charts/tree/master/bitnami/mongodb-sharded)

Mongo Sharding [docs](https://docs.mongodb.com/manual/sharding/)

- Chart Version: `3.9.1`

# Installation

## Namespace

```sh
NS=tools
```

## TLS certs

```sh
  mkdir -p ./mongo-sharded/certs

  # Generate server cert and key
  openssl req -newkey rsa:2048 -nodes -days 1095 \
  -keyout ./mongo-sharded/certs/mongo-server.key.pem \
  -out ./mongo-sharded/certs/mongo-server.req.pem \
  -subj "/C=SP/ST=Sao Paulo/L=Sao Paulo/O=Rpolnx/OU=Mongo Server/CN=rpolnx.com.br"

  # Sign in server cert from root ca
  openssl x509 -req -days 1095 -CAcreateserial \
  -in ./mongo-sharded/certs/mongo-server.req.pem \
  -out ./mongo-sharded/certs/mongo-server.cert.pem \
  -CA ./root-ca/certs/ca.cert.pem \
  -CAkey ./root-ca/certs/ca.key.pem \
  -extensions SAN \
  -extfile <(cat /etc/ssl/openssl.cnf \
    <(printf "\n[SAN]\nsubjectAltName=DNS:*.msc.$NS.svc.cluster.local,DNS:*.msc-headless.$NS.svc.cluster.local,DNS:*.$NS.svc.cluster.local,DNS:localhost,IP:127.0.0.1"))

  # create file
  cat ./mongo-sharded/certs/mongo-server.cert.pem ./mongo-sharded/certs/mongo-server.key.pem > ./mongo-sharded/certs/mongo-server.pem

  # Remove files
  rm ./mongo-sharded/certs/mongo-server.req.pem
  rm ./mongo-sharded/certs/mongo-server.cert.pem
  rm ./mongo-sharded/certs/mongo-server.key.pem

```

## Generate client cert and sign in server

```sh
  # Generate client cert and key
  openssl req -newkey rsa:2048 -nodes -days 1095 \
  -keyout ./mongo-sharded/certs/mongo-client.key.pem \
  -out ./mongo-sharded/certs/mongo-client.req.pem \
  -subj "/C=SP/ST=Sao Paulo/L=Sao Paulo/O=Rpolnx/OU=Mongo Client/CN=rpolnx.com.br"

  # Sign in server cert from root ca
  openssl x509 -req -days 1095 -CAcreateserial \
  -in ./mongo-sharded/certs/mongo-client.req.pem \
  -out ./mongo-sharded/certs/mongo-client.cert.pem \
  -CA ./root-ca/certs/ca.cert.pem \
  -CAkey ./root-ca/certs/ca.key.pem \
  -extensions SAN \
  -extfile <(cat /etc/ssl/openssl.cnf \
    <(printf "\n[SAN]\nsubjectAltName=DNS:*.msc.$NS.svc.cluster.local,DNS:*.msc-headless.$NS.svc.cluster.local,DNS:*.$NS.svc.cluster.local,DNS:localhost,IP:127.0.0.1"))

  # create file
  cat ./mongo-sharded/certs/mongo-client.cert.pem ./mongo-sharded/certs/mongo-client.key.pem > ./mongo-sharded/certs/mongo-client.pem

  # Remove files
  rm ./mongo-sharded/certs/mongo-client.req.pem
  rm ./mongo-sharded/certs/mongo-client.cert.pem
  rm ./mongo-sharded/certs/mongo-client.key.pem
```

## Secrets and configs

```sh
# Generate root password
MONGO_ROOT_PASSWORD=$(openssl rand -base64 20)

# Generate secret

kubectl -n $NS create secret generic mongo-secret \
--from-literal "mongodb-root-password=$MONGO_ROOT_PASSWORD" \
--from-literal "mongodb-replica-set-key=rskey1" \
--from-file "mongo-server-pem=./mongo-sharded/certs/mongo-server.pem" \
--from-file "mongo-client-pem=./mongo-sharded/certs/mongo-client.pem" \
--from-file "ca-cert=./root-ca/certs/ca.cert.pem"

```

## Installing mongodb sharded chart

```sh

  helm repo add bitnami https://charts.bitnami.com/bitnami

  helm upgrade --install --version 3.9.1 -n $NS mongo-sharded-cluster bitnami/mongodb-sharded \
  --values "./mongo-sharded/values.yaml" \
  --set "fullnameOverride=msc" \
  --set "mongodbRootPassword=$(k get -n $NS secret mongo-secret -o=jsonpath='{.data.mongodb-root-password}' | base64 -d)" \
  --set "replicaSetKey=$(k get -n $NS secret mongo-secret -o=jsonpath='{.data.mongodb-replica-set-key}' | base64 -d)" \
  --set "existingSecret=mongo-secret" \
  --set "shards=2" \
  --set "service.type=LoadBalancer" \
  --set "configsvr.replicas=1" \
  --set "configsvr.persistence.size=3Gi" \
  --set "mongos.replicas=2" \
  --set "shardsvr.dataNode.replicas=2" \
  --set "shardsvr.persistence.size=3Gi" \
  --set "configsvr.mongodbExtraFlags={--wiredTigerCacheSizeGB=0.25}" \
  --set "mongos.mongodbExtraFlags={}" \
  --set "shardsvr.mongodbExtraFlags={--wiredTigerCacheSizeGB=0.25,--inMemorySizeGB=0.25}" \
  --set "common.extraVolumes=
- name: certs-volume
  secret:
    secretName: mongo-secret
    items:
      - key: mongo-client-pem
        path: mongodb-client.pem
        mode: 384
      - key: mongo-server-pem
        path: mongodb-server.pem
        mode: 384
      - key: ca-cert
        path: mongodb-ca-cert
        mode: 384" \
  --set "common.extraVolumeMounts=
- name: certs-volume
  mountPath: /certs" \
  --set "common.extraEnvVars=
- name: MONGODB_CLIENT_EXTRA_FLAGS
  value: --tls --tlsCertificateKeyFile=/certs/mongodb-client.pem --tlsCAFile=/certs/mongodb-ca-cert
- name: MONGODB_EXTRA_FLAGS
  value: --tlsMode=preferTLS --tlsCertificateKeyFile=/certs/mongodb-server.pem --tlsCAFile=/certs/mongodb-ca-cert" \
  --set "livenessProbe.enabled=false" \
  --set "readinessProbe.enabled=false" \
  --set "common.mongodbSystemLogVerbosity=1" \
  --set "image.debug=true"


# --set "mongos.servicePerReplica.enabled=true" \

# --set "mongos.servicePerReplica.type=LoadBalancer" \

```

# Testing

** Please be patient while the chart is being deployed **

The MongoDB&reg; Sharded cluster can be accessed via the Mongos instances in port 27017 on the following DNS name from within your cluster:

`msc.$NS.svc.cluster.local`

To get the root password run:

```sh
    export MONGODB_ROOT_PASSWORD=$(kubectl get secret --namespace $NS mongo-secret \
     -o jsonpath="{.data.mongodb-root-password}" | base64 --decode)
```

To connect to your database run the following command:

```sh
    kubectl run --namespace $NS msc-client \
    --rm --tty -i --restart='Never' --image docker.io/bitnami/mongodb-sharded:4.4.8-debian-10-r9 \
    -command -- mongo admin --host msc
```

To connect to your database from outside the cluster execute the following commands:

NOTE: It may take a few minutes for the LoadBalancer IP to be available.
Watch the status with: 'kubectl get svc --namespace $NS -w msc'

```sh
    export SERVICE_IP=$(kubectl get svc --namespace $NS msc \
    --include "{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}")

    mongo --host $SERVICE_IP --port 27017 --authenticationDatabase admin -p $MONGODB_ROOT_PASSWORD
```
