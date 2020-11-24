# pto-portefolje-opendistro-elasticsearch

## Install (prerequisites)
`brew install coreutils helm`

## Install
1. `./scripts/generate_certs.sh`
2. `./scripts/generate_kubernetes_secrets.sh <dev|prod> pto pto-portefolje <password>`   
3. `helm install -f values-<dev|prod>.yaml pto-portefolje .`

## Uninstall
`./scripts/uninstall.sh`

## Access Kibana
1. `kubectl port-forward -n pto svc/pto-portefolje-opendistro-elasticsearch-kibana 5601`
2. Go to https://localhost:5601

## Access elasticsearch
1. `kubectl port-forward -n pto svc/pto-portefolje-opendistro-elasticsearch 9200`
2. curl http://localhost:9200 (Basic auth med -u admin:<PASSWORD>)
