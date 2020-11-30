#!/usr/bin/env bats

@test "the main tags are created" {
  id=`bash -c "docker images graze/php-alpine:8.0 --format '{{.ID}}'"`
  run bash -c "docker images graze/php-alpine --format '{{.ID}} ({{.Tag}})' | grep $id"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [[ "$output" == *"(8.0"* ]]

  [[ "$output" == *"(8)"* ]]
  [[ "$output" != *"(latest)"* ]]

  [[ "$output" != *"(8-test)"* ]]
  [[ "$output" != *"(8.0-test)"* ]]
  [[ "$output" != *"(test)"* ]]
}

@test "the test tags are created" {
  id=`bash -c "docker images graze/php-alpine:8.0-test --format '{{.ID}}'"`
  run bash -c "docker images graze/php-alpine --format '{{.ID}} ({{.Tag}})' | grep $id"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [[ "$output" == *"(8.0-test)"* ]]

  [[ "$output" == *"(8-test)"* ]]
  [[ "$output" != *"(test)"* ]]
  [[ "$output" != *"(latest)"* ]]
}
