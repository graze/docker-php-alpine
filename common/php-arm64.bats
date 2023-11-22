#!/usr/bin/env bats

@test "the image does not return any warnings" {
  run docker run --platform linux/arm64 ${container} php -m
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [[ "${output}" != *"PHP Warning"* ]]
  [[ "${output}" != *"PHP Notice"* ]]
}
