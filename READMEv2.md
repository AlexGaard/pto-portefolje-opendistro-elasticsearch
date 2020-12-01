# pto-portefolje-opendistro-elasticsearch

## Install (prerequisites)
`brew install coreutils helm`

## Install
1. `./scripts/generate_certs.sh`
2. `./scripts/generate_kubernetes_secrets.sh <dev|prod> pto pto-portefolje <password>`   
3. `helm install -f values-<dev|prod>.yaml pto-portefolje .`

## Uninstall
`./scripts/uninstall.sh`

## Delete persistent data
List volume claims
`kubectl get pvc -n pto`

Delete all the claims that are listed which is related to the cluster
`kubectl delete pvc storage-pto-portefolje-opendistro-elasticsearch-data-{0,1,2...}`
`kubectl delete pvc storage-pto-portefolje-opendistro-elasticsearch-master-{0,1,2...}`

## Setup new cluster
 
### Create user
```
curl --request PUT \
  --url https://localhost:9200/_opendistro/_security/api/internalusers/veilarb \
  --header 'Authorization: Basic <base64Creds>' \
  --header 'Content-Type: application/json'
  --data '{
	"password": "<password>",
	"backend_roles": ["admin"]
}'
```

### Create initial index
curl --request PUT \
  --url https://localhost:9200/brukerindeks-initial \
  --header 'Authorization: Basic <base64Creds>' \
  --header 'Content-Type: application/json' \
  --data '<JSON settings goes here>'
  
### Create alias 
curl --request PUT \
  --url https://localhost:9200/brukerindeks-initial/_alias/brukerindeks \
  --header 'Authorization: Basic <base64Creds>' \

## Access Kibana
1. `kubectl port-forward -n pto svc/pto-portefolje-opendistro-elasticsearch-kibana 5601`
2. Go to https://localhost:5601

## Access elasticsearch
1. `kubectl port-forward -n pto svc/pto-portefolje-opendistro-elasticsearch 9200`
2. curl http://localhost:9200 (Basic auth med -u admin:<PASSWORD>)

## Info
https://opendistro.github.io/for-elasticsearch-docs/version-history/
