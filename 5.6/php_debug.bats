#!/usr/bin/env bats

@test "the image has the the xdebug module installed" {
  run docker run --rm ${container} php -m
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [[ "${output}" == *xdebug* ]]
}
