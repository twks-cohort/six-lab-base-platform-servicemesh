#!/usr/bin/env bash
set -e

export CLUSTER=$1
export CLUSTER_DOMAINS=$(cat environments/$CLUSTER.install.json | jq -r .cluster_domains)
declare -a domain=($(echo $CLUSTER_DOMAINS | jq -r '.[0]'))

# deploy and test an nginx server on same account domain
bash scripts/deploy_nginx.sh ${domain}
sleep 5

CLUSTER=$CLUSTER bats test/validate_cdicohorts_digital.bats

kubectl delete -f nginx_server.yaml
kubectl delete configmap -n istio-system nginx-configmap
