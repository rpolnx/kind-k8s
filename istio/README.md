# Install istio


## Istio from cli

```sh
    istioctl install --set profile=demo --vklog=9 -y
```

### Testing

```sh

 kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.10/samples/bookinfo/platform/kube/bookinfo.yaml
 kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.10/samples/bookinfo/networking/bookinfo-gateway.yaml
```

## Multiple ingress gateways

```sh
    istioctl profile dump --config-path components.ingressGateways > ingress-gateway.yaml # see infos

    istioctl install -f istio-operator-2-gw.yaml
```

### Testing

```sh
 kubectl apply -f istio-gw-default.yaml 
 kubectl apply -f istio-gw-staging.yaml
```