#!/usr/bin/env bash
set -e
SCRIPTPATH=$(dirname $(realpath -s $0))
cd $SCRIPTPATH/..
ENVIRONMENT=$1
NAMESPACE=$2
RELEASE_NAME=$3
PASSWORD=$4
HASH=$(docker run amazon/opendistro-for-elasticsearch sh /usr/share/elasticsearch/plugins/opendistro_security/tools/hash.sh -p $PASSWORD)

echo "generate kubernetes secret for $RELEASE_NAME certificates" 
kubectl create secret generic ${RELEASE_NAME}-opendistro-elasticsearch-certs -n $NAMESPACE \
  --from-file=root-ca.pem=.secrets/root-ca.pem \
  --from-file=admin-key.pem=.secrets/admin-key.pem \
  --from-file=admin.pem=.secrets/admin.pem \
  --from-file=monitor-key.pem=.secrets/monitor-key.pem \
  --from-file=monitor.pem=.secrets/monitor.pem \
  --from-file=node-key.pem=.secrets/node-key.pem \
  --from-file=node.pem=.secrets/node.pem

echo "generate kubernetes secret for certificates"
helm template $RELEASE_NAME --values values-${ENVIRONMENT}.yaml --set odfe.generate_secrets=true --set odfe.security.password.hash="$HASH" --show-only templates/odfe-config-secrets.yaml . | kubectl apply -n $NAMESPACE -f -

echo "generating secret for kibana"
helm template $RELEASE_NAME --values values-${ENVIRONMENT}.yaml --set odfe.env.TEAM=pto --set odfe.generate_secrets=true --set kibana.password="$PASSWORD" --show-only templates/odfe-kibana-secrets.yaml . | kubectl apply -n $NAMESPACE -f -

echo "generating secret for exporter"
helm template $RELEASE_NAME --values values-${ENVIRONMENT}.yaml --set odfe.env.TEAM=pto --set odfe.generate_secrets=true --set exporter.password="$PASSWORD" --show-only templates/odfe-prometheus-exporter-secrets.yaml . | kubectl apply -n $NAMESPACE -f -
