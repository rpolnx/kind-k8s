# Root CA keys and certificate

```sh

 # Generate keys and certificates
 # https://mariadb.com/docs/security/encryption/in-transit/create-self-signed-certificates-keys-openssl/

 # Prompty non interactive cert params
 # https://www.shellhacks.com/create-csr-openssl-without-prompt-non-interactive/

  mkdir -p ./root-ca/certs

  # Generate the private key of the root CA
  openssl genrsa -out ./root-ca/certs/tls.key 2048

  # Generate the self-signed root CA certificate
  openssl req -x509 -sha256 -new -nodes -key ./root-ca/certs/tls.key -days 2190 -out ./root-ca/certs/tls.crt \
  -subj "/C=SP/ST=Sao Paulo/L=Sao Paulo/O=Rpolnx/OU=IT Department/CN=rpolnx.com.br/emailAddress=rodrigorpogo@gmail.com/" # 3 years

  k get ns tools || kubectl create namespace tools

  kubectl create secret generic -n cert-manager ca-key-pair \
  --from-file=tls.crt=./root-ca/certs/tls.crt \
  --from-file=tls.key=./root-ca/certs/tls.key

```
