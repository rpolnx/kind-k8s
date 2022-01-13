# Cert-manager

## Repo info

Chart repository [github](https://github.com/bitnami/charts/tree/master/bitnami/redis)

Artifactory [artifacthub](https://artifacthub.io/packages/helm/bitnami/redis)

- Chart Version: `14.8.8`

## Installation

```sh
  ### TLS certs ###

  CERTS_BASE_PATH=./cert-manager

  mkdir -p $CERTS_BASE_PATH/certs

  # Generate server cert and key
  openssl req -newkey rsa:2048 -nodes -days 1095 \
  -keyout $CERTS_BASE_PATH/certs/redis-server.key.pem \
  -out $CERTS_BASE_PATH/certs/redis-server.req.pem \
  -subj "/C=SP/ST=Sao Paulo/L=Sao Paulo/O=Rpolnx/OU=Redis Server/CN=rpolnx.com.br" # 3 years

  # Sign in server cert from root ca
  openssl x509 -req -days 1095 -CAcreateserial \
  -in $CERTS_BASE_PATH/certs/redis-server.req.pem \
  -out $CERTS_BASE_PATH/certs/redis-server.cert.pem \
  -CA ./root-ca/certs/ca.cert.pem \
  -CAkey ./root-ca/certs/ca.key.pem
  -extensions SAN \
  -extfile <(cat /etc/ssl/openssl.cnf \
    <(printf "\n[SAN]\nsubjectAltName=DNS:*.svc.cluster.local"))

  # Generate client cert and key
  openssl req -newkey rsa:2048 -nodes -days 1095 \
  -keyout $CERTS_BASE_PATH/certs/redis-client.key.pem \
  -out $CERTS_BASE_PATH/certs/redis-client.req.pem \
  -subj "/C=SP/ST=Sao Paulo/L=Sao Paulo/O=Rpolnx/OU=Redis Client/CN=rpolnx.com.br" # 3 years

  # Sign in server cert from root ca
  openssl x509 -req -days 1095 -CAcreateserial \
  -in $CERTS_BASE_PATH/certs/redis-client.req.pem \
  -out $CERTS_BASE_PATH/certs/redis-client.cert.pem \
  -CA ./root-ca/certs/ca.cert.pem \
  -CAkey ./root-ca/certs/ca.key.pem \
  -extensions SAN \
  -extfile <(cat /etc/ssl/openssl.cnf \
    <(printf "\n[SAN]\nsubjectAltName=DNS:*.svc.cluster.local"))

  # (Optional) Verify certs
  openssl verify -CAfile ./root-ca/certs/ca.cert.pem ./root-ca/certs/ca.cert.pem $CERTS_BASE_PATH/certs/redis-server.cert.pem
  openssl verify -CAfile ./root-ca/certs/ca.cert.pem ./root-ca/certs/ca.cert.pem $CERTS_BASE_PATH/certs/redis-client.cert.pem

  ### Secrets and configs ###

  ### Installing redis chart ###

  helm repo add cert-manager https://charts.jetstack.io


  helm upgrade --install --version 1.6.1 --namespace cert-manager \
  --create-namespace cert-manager cert-manager/cert-manager \
  --set "webhook.timeoutSeconds=4"
```


  
## Using private CA

Generate CA key pair from "root-ca" README.md docs.

```sh
  k apply -f cert-manager/private_ca_issuer.yaml
```

## Gateway and VS with tls cert

```sh
  k apply -f cert-manager/private_ca_issuer.yaml
  k apply -f cert-manager/certificate.yaml
  k apply -f cert-manager/gateway.yaml
  k apply -f cert-manager/virtual-service.yaml
```