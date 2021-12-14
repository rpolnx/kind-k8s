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

 kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/master/manifests/namespace.yaml

 kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

 kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/master/manifests/metallb.yaml

 # Search docker network to apply on configmap
 docker network inspect -f '{{.IPAM.Config}}' kind
 kubectl apply -f metallb-configmap.yaml
```

## Istio from cli

```sh
istioctl install --set profile=demo --vklog=9 -y
```

## Rancher

```sh
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
kubectl create namespace cattle-system
```

### Cert manager (required from certified)

```sh
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.0.4/cert-manager.crds.yaml
kubectl create namespace cert-manager
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v1.0.4
```

### Instalation using lets encrypt

```sh
helm install rancher rancher-latest/rancher --namespace cattle-system \
    --set hostname=localhost --set replicas=1 --set ingress.tls.source=letsEncrypt --set letsEncrypt.email=localhost@gmail.com
```

### Testing

```sh
 k apply -f nginx-example.yaml

 kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.10/samples/bookinfo/platform/kube/bookinfo.yaml
 kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.10/samples/bookinfo/networking/bookinfo-gateway.yaml
```
