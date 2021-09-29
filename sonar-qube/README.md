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

  ### Installing redis chart ###

  helm repo add oteemocharts https://oteemo.github.io/charts

  helm upgrade --install --version 9.8.2 -n tools sonarqube oteemocharts/sonarqube \
  --values  "./sonar-qube/values.yaml" \
  --set     "service.type=LoadBalancer" \
  --set     "persistence.enabled=true" \
  --set     "postgresql.enabled=true" \
  --set     "createPostgresqlSecret=true" \
  --set     "postgresql.postgresqlUsername=sonarUser" \
  --set     "postgresql.postgresqlPassword=$PG_PASSWORD" \
  --set     "postgresql.postgresqlDatabase=sonarDB"

  k -n tools create secret generic 
```

```sh

  kubectl create secret generic -n tools sonarqube-admin \
  --from-literal password=$ADMIN_PASSWORD
```