# Loki


```
$ helm repo add grafana https://grafana.github.io/helm-charts
$ helm repo update
```


```
$ helm upgrade --install loki grafana/loki-distributed \
  --namespace loki --create-namespace \
  -f values.yml
```


