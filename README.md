# Kind k8s

# Introduction

Basic kind usage with some popular kubernetes components

[Starts here](https://kind.sigs.k8s.io/docs/user/quick-start/)

```sh
kind create cluster --config  cluster-kind.yml --name kind-common
```

## Requirements

- [Kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Kind](https://kind.sigs.k8s.io/)
- [Istioctl](https://istio.io/latest/docs/setup/install/istioctl/)

# Others Kubernetes components

## Metric Server

```sh
 kubectl apply -f components-ms.yaml
```

## Weave (Optional)

```sh
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
```

## MetalLB

Configuraton from the [docs](https://kind.sigs.k8s.io/docs/user/loadbalancer/)

```sh

 kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/namespace.yaml

 kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/metallb.yaml

 # Search docker network to apply on configmap
 docker network inspect -f '{{.IPAM.Config}}' kind
 kubectl apply -f metallb-configmap.yaml
```

## Nginx ingress controller

```sh
    helm repo add nginx-stable https://helm.nginx.com/stable
    helm repo update
    helm install nginx-ingress nginx-stable/nginx-ingress \
        --set nameOverride='nginx-ingress' \
        --set fullnameOverride='nginx-ingress'
```

## Istio from cli

```sh
    istioctl install --set profile=demo --vklog=9 -y
```

## Rancher

```sh

```

### Cert manager (required from certified)

```sh
kubectl apply --validate=false \
-f https://github.com/cert-manager/cert-manager/releases/download/v1.8.0/cert-manager.crds.yaml

helm repo add jetstack https://charts.jetstack.io
helm repo update

helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.8.0
```

### Instalation rancher

```sh
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
kubectl create namespace cattle-system
helm install rancher rancher-latest/rancher --namespace cattle-system \
    --set hostname=eks.rpolnx.com.br --set replicas=1 --set ingress.tls.source=letsEncrypt --set letsEncrypt.email=rodrigorpogo@gmail.com
```

### Testing

```sh
 k apply -f nginx-example.yaml

 kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.10/samples/bookinfo/platform/kube/bookinfo.yaml
 kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.10/samples/bookinfo/networking/bookinfo-gateway.yaml
```
