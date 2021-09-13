#!/bin/bash

certname=$1

openssl req -newkey \
  rsa:2048 \
  -keyout $BASE_CERT_PATH/$certname.key \
  -out $BASE_CERT_PATH/$certname.csr \
  -passin pass:$keystore_password \
  -passout pass:$keystore_password \
  -subj "/C=SP/ST=Sao Paulo/L=Sao Paulo/O=Rpolnx/OU=Kafka $certname/CN=rpolnx.com.br"

convert the key to PKCS8, otherwise kafka/java cannot read it
openssl pkcs8 \
  -topk8 \
  -in $BASE_CERT_PATH/$certname.key \
  -inform pem \
  -v1 PBE-SHA1-3DES \
  -out $BASE_CERT_PATH/$certname-pkcs8.key \
  -outform pem \
  -passin pass:$keystore_password \
  -passout pass:$keystore_password

#Using .key as pkcs8
mv $BASE_CERT_PATH/$certname-pkcs8.key $BASE_CERT_PATH/$certname.key

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












# while [ $count -le "$(($NUMBER_OF_BROKERS-1))" ]
# do

#     echo "Generating certs for broker #$count";
    
#     # Generate server cert and key
#     openssl req -newkey rsa:2048 -nodes -days 1095 \
#     -keyout ./kafka/certs/kafka-broker-$count.key.pem \
#     -out ./kafka/certs/kafka-broker-$count.req.pem \
#     -subj "/C=SP/ST=Sao Paulo/L=Sao Paulo/O=Rpolnx/OU=Kafka Server/CN=rpolnx.com.br" # 3 years

#     # Sign in server cert from root ca
#     openssl x509 -req -days 1095 -CAcreateserial \
#     -in ./kafka/certs/kafka-broker-$count.req.pem \
#     -out ./kafka/certs/kafka-broker-$count.cert.pem \
#     -CA ./root-ca/certs/ca.cert.pem \
#     -CAkey ./root-ca/certs/ca.key.pem \
#     -extensions SAN \
#     -extfile <(cat /etc/ssl/openssl.cnf \
#         <(printf "\n[SAN]\nsubjectAltName=DNS:*.msc.$NS.svc.cluster.local,DNS:*.msc-headless.$NS.svc.cluster.local,DNS:*.$NS.svc.cluster.local,DNS:localhost,IP:127.0.0.1"))

#     rm ./kafka/certs/kafka-broker-$count.req.pem

#     count=$(( $count + 1 ))
# done
