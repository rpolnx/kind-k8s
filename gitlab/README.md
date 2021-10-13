# Sonar Qube from Oteemo

## Repo info

Docs [Gitlab docs](https://docs.gitlab.com/charts/quickstart/index.html)

- Chart Version: `latest`

## Installation

```sh
  ### Installing redis chart ###

  helm repo add gitlab https://charts.gitlab.io/

  helm install -n tools gitlab gitlab/gitlab \
    --set global.hosts.domain=rpolnx.com.br \
    --set certmanager-issuer.email=rodrigorpogo@gmail.com


```

```sh
  PG_PASSWORD=$(openssl rand -base64 20)
  ADMIN_PASSWORD=$(openssl rand -base64 20)

  k -n tools create secret generic

  kubectl create secret generic -n tools sonarqube-admin \
  --from-literal password=$ADMIN_PASSWORD
```

## Golang CI steps

### Needs to configure properties

```sh
sonar.sources=.
sonar.exclusions=**/*_test.go

sonar.tests=.
sonar.test.inclusions=**/*_test.go

sonar.go.tests.reportPaths=report.json
sonar.go.coverage.reportPaths=coverage.out
```

### Run tests and generate configs

This commands will generate "coverage.out" and report.json

```sh

  go test -v ./test/... -coverpkg=./... -coverprofile="coverage.out" -covermode=count -json > report.json;
  
  # for multiple packages
  go test -v ./test/... -coverpkg=./application/...,./domain/...,./infrastructure/... \
  -coverprofile="coverage.out" -covermode=count -json > report.json;
  
  go tool cover -func coverage.out
```
