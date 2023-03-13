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
 helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/

 helm upgrade -i -n kube-system metrics-server metrics-server/metrics-server \
 --set "args={--kubelet-insecure-tls=true}" \
 --set apiService.insecureSkipTLSVerify=true
```

## Weave (Optional)

```sh
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
```

## MetalLB

Configuraton from the [docs](https://kind.sigs.k8s.io/docs/user/loadbalancer/)

```sh

 helm repo add metallb https://metallb.github.io/metallb

 helm upgrade -i -n kube-system metallb metallb/metallb

#  docker network inspect -f '{{.IPAM.Config}}' kind

# set automatic docker IPAM ip to metallb-confimap
 docker network inspect kind | jq -r '.[0].IPAM.Config[0].Subnet' | \
   sed -e 's/\.0\/.*//g' | read DOCKER_POOL_IP_BASE && \
   echo "${DOCKER_POOL_IP_BASE}.200-${DOCKER_POOL_IP_BASE}.255" | 
   read METALLB_POOL && \
   sed -i "s/172.*/$METALLB_POOL/g" metallb-configmap.yaml
 
 kubectl apply -f metallb-configmap.yaml
```

## Nginx ingress controller

```sh
    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

    helm repo update
    helm upgrade -n kube-system -i nginx-ingress ingress-nginx/ingress-nginx
```

## Istio from cli

```sh
    # istioctl install --set profile=demo --vklog=9 -y

  helm repo add istio https://istio-release.storage.googleapis.com/charts
  helm repo update

  kubectl create namespace istio-system
  helm install istio-base istio/base -n istio-system
  helm install istiod istio/istiod -n istio-system --wait

  kubectl create namespace istio-system
  kubectl label namespace istio-system istio-injection=enabled
  helm install istio-ingress istio/gateway -n istio-system --wait

```

## Rancher

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

## Monitoring

### Node Exporter

```sh

  helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
  helm repo update

  k create ns monitoring || echo "ns already exists"
  NS=monitoring

  helm upgrade -i -n $NS prometheus-stack prometheus-community/kube-prometheus-stack \
  --set "grafana.adminPassword=password"

```

# Testing

```sh
 k apply -f nginx-example.yaml

 kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.10/samples/bookinfo/platform/kube/bookinfo.yaml
 kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.10/samples/bookinfo/networking/bookinfo-gateway.yaml
```
