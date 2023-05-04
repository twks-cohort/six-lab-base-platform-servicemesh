#!/usr/bin/env bats

@test "evaluate cdicohorts-six.com ingress" {
  run bash -c "curl https://httpbin.${CLUSTER}.cdicohorts-six.com/status/418"
  [[ "${output}" =~ "-=[ teapot ]=-" ]]
}

@test "evaluate cdicohorts-six.com certificate" {
  run bash -c "curl --cert-status -v https://httpbin.${CLUSTER}.cdicohorts-six.com/status/418"
  [[ "${output}" =~ "SSL certificate verify ok" ]]
}