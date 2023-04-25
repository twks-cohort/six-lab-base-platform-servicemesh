#!/usr/bin/env bash
set -e

export CLUSTER=$1

# deploy and test httpbin on same account domain
bash scripts/deploy_httpbin.sh ${CLUSTER}
sleep 30

bats test/validate_cdicohorts_digital.bats

kubectl delete -f httpbin-cdicohorts-digital-gateway.yaml
