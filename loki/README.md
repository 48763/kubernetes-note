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



```
docker run --rm grafana/loki-benchmark:latest \
  -rate 10000 \
  -duration 1m \
  -batch-size 1000 \
  -workers 10 \
  -entry-size 256 \
  -push-url http://10.0.0.4:3100/api/prom/push
```