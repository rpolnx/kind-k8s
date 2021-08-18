# Root CA keys and certificate

```sh

 # Generate keys and certificates
 # https://mariadb.com/docs/security/encryption/in-transit/create-self-signed-certificates-keys-openssl/

 # Prompty non interactive cert params
 # https://www.shellhacks.com/create-csr-openssl-without-prompt-non-interactive/

  mkdir -p ./root-ca/certs

  # Generate the private key of the root CA
  openssl genrsa -out ./root-ca/certs/ca.key.pem 2048

  # Generate the self-signed root CA certificate
  openssl req -x509 -sha256 -new -nodes -key ./root-ca/certs/ca.key.pem -days 1095 -out ./root-ca/certs/ca.cert.pem \
  -subj "/C=SP/ST=Sao Paulo/L=Sao Paulo/O=Rpolnx/OU=IT Department/CN=rpolnx.com.br" # 3 years

  k get ns tools || kubectl create namespace tools

  kubectl create secret generic -n tools ca-cert \
  --from-file=ca-cert=./root-ca/certs/ca.cert.pem \
  --from-file=ca-key=./root-ca/certs/ca.key.pem

```
