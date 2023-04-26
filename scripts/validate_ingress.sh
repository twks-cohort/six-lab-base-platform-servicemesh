#!/usr/bin/env bash
set -e

export DOMAIN=$1

# deploy and test an nginx server on same account domain
bash scripts/deploy_nginx.sh ${DOMAIN}
sleep 5

bats test/validate_cdicohorts_digital.bats

kubectl delete -f nginx_server.yaml
kubectl delete configmap -n istio-system nginx-configmap
