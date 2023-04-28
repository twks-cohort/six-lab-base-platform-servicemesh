#!/usr/bin/env bats

@test "evaluate cdicohorts-six.com ingress" {
  run bash -c "curl https://nginx.cdicohorts-six.com"
  [[ "${output}" =~ "the nginx web server is successfully installed" ]]
}

@test "evaluate cdicohorts-six.com certificate" {
  run bash -c "curl --cert-status -v https://nginx.cdicohorts-six.com"
  [[ "${output}" =~ "SSL certificate verify ok" ]]
}
