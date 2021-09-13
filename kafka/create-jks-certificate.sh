#! /bin/bash

certname=$1
password=$keystore_password

rm $BASE_CERT_PATH/$certname*

# Create a keystore
keytool -genkeypair \
  -alias $certname \
  -keyalg RSA \
  -keysize 2048 \
  -validity 1000 \
  -keystore $BASE_CERT_PATH/$certname.keystore.jks \
  -dname "CN=$certname,OU=Kafka SSL,O=Rpolnx,L=Sao Paulo,C=SP" \
  -ext "SAN=dns:$certname,dns:localhost,dns:*.$NS.svc.cluster.local" \
  -storepass $password \
  -keypass $password \
  -storetype pkcs12

echo 'Creating signing request'
# create a CSR
keytool -certreq \
  -sigAlg SHA256withRSA \
  -alias $certname \
  -file $BASE_CERT_PATH/$certname.csr \
  -keystore $BASE_CERT_PATH/$certname.keystore.jks \
  -ext "SAN=dns:$certname,dns:localhost,dns:*.$NS.svc.cluster.local" \
  -storepass $password \
  -keypass $password


echo 'Signing request with CA'
# Sign the CSR with the root CA
openssl x509 -req \
  -CA $BASE_CERT_PATH/$root_cert \
  -CAkey $BASE_CERT_PATH/$root_key \
  -in $BASE_CERT_PATH/$certname.csr \
  -out $BASE_CERT_PATH/$certname-signed.crt \
  -sha256 \
  -days 1000 \
  -CAcreateserial \
  -passin pass:$truststore_password \
  -extensions v3_req \
  -extfile <(cat <<EOF
[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no
[req_distinguished_name]
CN = $certname
[v3_req]
subjectAltName = @alt_names
[alt_names]
DNS.1 = $certname
DNS.2 = localhost
DNS.3 = *.$NS.svc.cluster.local
EOF
)

# import the root CA into the keystore
keytool -import \
  -noprompt \
  -keystore $BASE_CERT_PATH/$certname.keystore.jks \
  -alias root-ca \
  -file $BASE_CERT_PATH/$root_cert \
  -storepass $password \
  -keypass $password

# import signed cert into the keystore
keytool -import \
  -noprompt \
  -keystore $BASE_CERT_PATH/$certname.keystore.jks \
  -alias $certname \
  -file $BASE_CERT_PATH/$certname-signed.crt \
  -storepass $password \
  -keypass $password \
  -ext "SAN=dns:$certname,dns:localhost,dns:*.$NS.svc.cluster.local"

