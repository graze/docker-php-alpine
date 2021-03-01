#!/usr/bin/env bats

@test "the image has phpdbg" {
  run docker run ${container} which phpdbg8
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [[ "${output}" == *"phpdbg8"* ]]
}
