# Root CA keys and certificate

```sh

 # Generate keys and certificates
 # https://mariadb.com/docs/security/encryption/in-transit/create-self-signed-certificates-keys-openssl/

 # Prompty non interactive cert params
 # https://www.shellhacks.com/create-csr-openssl-without-prompt-non-interactive/

  SUBDOMAIN=rpolnx.local

  mkdir -p ./root-ca/certs

  # Generate the private key of the root CA
  openssl genrsa -out ./root-ca/certs/tls.key 4096 # -passout pass:pass -des3

  # Generate the self-signed root CA certificate
  openssl req -x509 -new -nodes -key ./root-ca/certs/tls.key -sha256 -days 2048 -out ./root-ca/certs/tls.crt \
  -subj "/C=SP/ST=Sao Paulo/L=Sao Paulo/O=Rpolnx/OU=IT Department/CN=Rpolnx CA Cert/emailAddress=rodrigorpogo@gmail.com/"
  # -passin pass:pass

  kubectl create secret generic -n cert-manager ca-key-pair \
  --from-file=tls.crt=./root-ca/certs/tls.crt \
  --from-file=tls.key=./root-ca/certs/tls.key

```
