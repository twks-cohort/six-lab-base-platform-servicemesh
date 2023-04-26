#!/usr/bin/env bats

@test "evaluate cdicohorts.digital ingress" {
  run bash -c "curl https://httpbin.cdicohorts.digital/status/418"
  [[ "${output}" =~ "-=[ teapot ]=-" ]]
}

@test "evaluate cdicohorts.digital certificate" {
  run bash -c "curl --cert-status -v https://httpbin.cdicohorts.digital/status/418"
  [[ "${output}" =~ "SSL certificate verify ok" ]]
}
