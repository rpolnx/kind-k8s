# Sonar Qube from Oteemo

## Repo info

Artifactory [artifacthub](https://artifacthub.io/packages/helm/oteemo-charts/sonarqube)

Chart repository [github](https://github.com/Oteemo/charts/tree/master/charts/sonarqube)

Docs [Sonar docs](https://docs.sonarqube.org/latest/)

- Chart Version: `9.8.2`

## Installation

```sh

  PG_PASSWORD=$(openssl rand -base64 20)
  ADMIN_PASSWORD=$(openssl rand -base64 20)

  ### Installing sonar chart ###

  helm repo add oteemocharts https://oteemo.github.io/charts

  helm upgrade --install --version 9.8.2 sonarqube oteemocharts/sonarqube \
  --set     "service.type=ClusterIP" \
  --set     "persistence.enabled=true" \
  --set     "postgresql.enabled=true" \
  --set     "createPostgresqlSecret=true" \
  --set     "postgresql.postgresqlUsername=sonarUser" \
  --set     "postgresql.postgresqlPassword=$PG_PASSWORD" \
  --set     "postgresql.postgresqlDatabase=sonarDB"
  # -n tools
```

```sh

  kubectl create secret generic sonarqube-admin \
  --from-literal password=$ADMIN_PASSWORD
```

```sh
# get password
SONAR_USER=admin
SONAR_PASSWORD=admin # default
SONAR_PASSWORD=$(kubectl get secrets sonarqube-admin -o json \
 | jq '.data | map_values(@base64d)' \
 | jq '.password' | sed -e 's/"//g')

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
  go test -v ./test/... -coverpkg=./... \
  -coverprofile="coverage.out" -covermode=count -json > report.json;
  
  go tool cover -func coverage.out
```

```sh
# sonar-scanner \
#   -Dsonar.projectKey=project-test \
#   -Dsonar.sources=. \
#   -Dsonar.host.url=https://sonar.rpolnx.local \
#   -Dsonar.login=a0166917d40ab48afba1df2ee409b1b357f29c2f \
#   -Dsonar.qualitygate.wait=true


docker run --rm --network=host \
    -e SONAR_HOST_URL="http://sonar.rpolnx.local" \
    -e SONAR_LOGIN="a0166917d40ab48afba1df2ee409b1b357f29c2f" \
    -v "/home/rpolnx/Documents/fcamara/repos/ramais-store:/usr/src" \
    sonarsource/sonar-scanner-cli:latest \
    -Dsonar.projectKey=project-test \
    -Dsonar.projectName=ramais-store \
    -Dsonar.projectVersion=1.0.0 \
    -Dsonar.sources=. \
    -Dsonar.exclusions="./test/*.go" \
    -Dsonar.tests="." \
    -Dsonar.test.inclusions="./test/*.go" \
    -Dsonar.go.tests.reportPaths="report.json" \
    -Dsonar.go.coverage.reportPaths="coverage.out" \
    -Dsonar.qualitygate.wait=true

```
docker run -ti -v ${pwd}:/root/src — link sonarqube newtmitch/sonar-scanner:4 -Dsonar.host.url=http://sonarqube:9000 -Dsonar.scm.provider=git -Dsonar.projectBaseDir=/root/src -Dsonar.sources=. -Dsonar.projectName=”Web App with Database Demo”