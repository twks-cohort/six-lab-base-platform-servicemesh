#!/usr/bin/env bats

@test "evaluate cdicohorts.digital ingress" {
  run bash -c "curl https://nginx.cdicohorts.digital"
  [[ "${output}" =~ "the nginx web server is successfully installed" ]]
}

@test "evaluate cdicohorts.digital certificate" {
  run bash -c "curl --cert-status -v https://nginx.cdicohorts.digital"
  [[ "${output}" =~ "SSL certificate verify ok" ]]
}
