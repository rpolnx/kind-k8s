# Prometheus Kube Stack

## Repo info

Chart repository [main page](https://github.com/prometheus-operator/kube-prometheus)

Artifactory [artifacthub](https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack)

- Chart Version: `43.1.4`

## Installation

Install
- Alert manager
- Prometheus Operator
- Prometheus
- NodeExporter

### Installing prometheus stack

```sh
  helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

  helm repo update

  k create ns monitoring || echo "ns already exists"
  NS=monitoring

  helm upgrade --install -n $NS prometheus-stack prometheus-community/kube-prometheus-stack #43.1.4

```

---

# Optional other option


# Bitnami Kube Prometheus

Install
- Alert manager
- Prometheus Operator
- Prometheus

## Repo info

Chart repository [main page](https://github.com/prometheus-operator/kube-prometheus)

Artifactory [artifacthub](https://artifacthub.io/packages/helm/bitnami/kube-prometheus)

- Chart Version: `8.1.7`

## Installation

### Installing bitnami kube prometheus

```sh
  helm repo add bitnami https://charts.bitnami.com/bitnami

  helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

  helm repo update

  NS=default

  helm upgrade --install -n $NS kube-prometheus bitnami/kube-prometheus \
  --version 8.1.7
  # --values  "./values.yaml"
  # --set     "server.service.type=LoadBalancer"

```