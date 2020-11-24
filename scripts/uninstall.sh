helm uninstall pto-portefolje
kubectl delete secret pto-portefolje-opendistro-elasticsearch-certs -n pto
kubectl delete secret pto-portefolje-opendistro-elasticsearch-config -n pto
kubectl delete secret pto-portefolje-opendistro-elasticsearch-exporter-secrets -n pto
kubectl delete secret pto-portefolje-opendistro-elasticsearch-kibana-secrets -n pto
