# Bitnami redis

```sh
  ### TLS certs ###

  mkdir -p ./redis/certs

  # Generate server cert and key
  openssl req -newkey rsa:2048 -nodes -days 1095 \
  -keyout ./redis/certs/redis-server.key.pem \
  -out ./redis/certs/redis-server.req.pem \
  -subj "/C=SP/ST=Sao Paulo/L=Sao Paulo/O=Rpolnx/OU=Redis Server/CN=rpolnx.com.br" # 3 years

  # Sign in server cert from root ca
  openssl x509 -req -days 1095 -set_serial 01 \
  -in ./redis/certs/redis-server.req.pem \
  -out ./redis/certs/redis-server.cert.pem \
  -CA ./root-ca/certs/ca.cert.pem \
  -CAkey ./root-ca/certs/ca.key.pem


  # Generate client cert and key
  openssl req -newkey rsa:2048 -nodes -days 1095 \
  -keyout ./redis/certs/redis-client.key.pem \
  -out ./redis/certs/redis-client.req.pem \
  -subj "/C=SP/ST=Sao Paulo/L=Sao Paulo/O=Rpolnx/OU=Redis Client/CN=rpolnx.com.br" # 3 years

  # Sign in server cert from root ca
  openssl x509 -req -days 1095 -set_serial 01 \
  -in ./redis/certs/redis-client.req.pem \
  -out ./redis/certs/redis-client.cert.pem \
  -CA ./root-ca/certs/ca.cert.pem \
  -CAkey ./root-ca/certs/ca.key.pem

  # (Optional) Verify certs
  openssl verify -CAfile ./root-ca/certs/ca.cert.pem ./root-ca/certs/ca.cert.pem ./redis/certs/redis-server.cert.pem
  openssl verify -CAfile ./root-ca/certs/ca.cert.pem ./root-ca/certs/ca.cert.pem ./redis/certs/redis-client.cert.pem

  ### Secrets and configs ###

  # generate password
  REDIS_PASSWORD=$(openssl rand -base64 20)
  # REDIS_PASSWORD=$(k get -n tools secret redis-secret -o=jsonpath='{.data.password}' | base64 -d)

  # Generate secret
  kubectl create secret generic -n tools redis-secret \
  --from-literal password=$REDIS_PASSWORD \
  --from-file redis-cert=./redis/certs/redis-server.cert.pem \
  --from-file redis-key=./redis/certs/redis-server.key.pem \
  --from-file ca-cert=./root-ca/certs/ca.cert.pem

  ### Installing redis chart ###
  VERSION=14.8.8

  helm repo add bitnami https://charts.bitnami.com/bitnami

  helm upgrade --install --version $VERSION -n tools redis-cluster bitnami/redis \
  --values  "./redis/values.yaml" \
  --set     "master.service.type=LoadBalancer" \
  --set     "master.persistence.size=1Gi" \
  --set     "replica.persistence.size=1Gi" \
  --set     "replica.service.type=LoadBalancer" \
  --set     "replica.replicaCount=3" \
  --set     "auth.enabled=true" \
  --set     "auth.existingSecret=redis-secret" \
  --set     "auth.existingSecretPasswordKey=password" \
  --set     "tls.enabled=true" \
  --set     "tls.existingSecret=redis-secret" \
  --set     "tls.certFilename=redis-cert" \
  --set     "tls.certKeyFilename=redis-key" \
  --set     "tls.certCAFilename=ca-cert"
```
