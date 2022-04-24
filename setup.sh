#!/bin/bash
set -e

#kind delete cluster --name kind-common

kind create cluster --config  cluster-kind.yml --name kind-common

kubectl apply -f components-ms.yaml

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/namespace.yaml

kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/metallb.yaml

BASE_SUBNET=$(docker network inspect kind | jq '.[0].IPAM.Config[0].Subnet' | sed -e 's/\"//g')
INITIAL_ADDRESS=$(echo -n $BASE_SUBNET | sed -E "s/(0.).*/\1200/" )
LAST_ADDRESS=$(echo -n $BASE_SUBNET | sed -E "s/(0.).*/\1255/" )

SUBNET_RANGE="$INITIAL_ADDRESS-$LAST_ADDRESS"
sed -i -E "s/(172.).*/$SUBNET_RANGE/" metallb-configmap.yaml

kubectl apply -f metallb-configmap.yaml

helm install nginx-ingress nginx-stable/nginx-ingress \
    --set nameOverride='nginx-ingress' \
    --set fullnameOverride='nginx-ingress'

istioctl install --set profile=demo --vklog=3 -y

kubectl apply --validate=false \
-f https://github.com/cert-manager/cert-manager/releases/download/v1.8.0/cert-manager.crds.yaml

helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.8.0

kubectl apply -f nginx-example.yaml
