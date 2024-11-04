### 1. Install Grafana

```
oc apply -f manifests/k8s/grafana.yaml -n grafana
```


### 2. Create ServiceAccount for grafana to access data of prometheus

```
oc apply -f manifests/k8s/prometheus-datasource-sa.yaml -n grafana
```


### 3. Test in grafana pod

```
TOKEN=$(oc create token prometheus-datasource-sa -n grafana)
oc exec -it <grafana-pod-name> -- bash
```

```
curl -k https://thanos-querier-openshift-monitoring.apps.ocp.dev.net/api/v1/status/flags -H "Authorization: Bearer <TOKEN>"
```


### 4. Loging to grafana web UI and create a Service Account (inside grafana)

#### Create a service account

Name: grafana-datasource-editor
Roles: Admin (need for write datasource)

#### Add service account token (your-grafana-api-key)

Name: ocp-prometheus-datasource-updater

#### Verify in grafana pod

```
curl -H "Authorization: Bearer <YOUR_SERVICE_ACCOUNT_TOKEN>" http://<grafana-server>/api/datasources
```


### 5. Create a Prometheus Datasource (using grafana Web UI)

Connection
- Prometheus server URL= https://thanos-querier-openshift-monitoring.apps.ocp.dev.net


### 6. Create a cronjob to update authorization token of Prometheus datasource

```
oc create secret docker-registry my-dockerhub-secret \
  --docker-server=docker.io \
  --docker-username=<your-dockerhub-username> \
  --docker-password=<your-dockerhub-password> \
  --docker-email=<your-email>
```

```
kubectl create secret generic grafana-credentials \
  --from-literal=GRAFANA_API_KEY=<your-grafana-api-key> \
  --from-literal=GRAFANA_URL=http://<grafana-service-url>:3000 \
  -n grafana
```

```
kubectl create configmap prometheus-config \
  --from-literal=PROMETHEUS_URL=https://thanos-querier-openshift-monitoring.apps.ocp.dev.net \
  -n grafana
```

```
oc apply -f manifests/k8s/cronjob-sa-and-rb.yaml
oc apply -f manifests/ocp/cronjob.yaml
```
