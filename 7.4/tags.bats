#!/usr/bin/env bats

@test "the main tags are created" {
  id=`bash -c "docker images graze/php-alpine:7.4 --format '{{.ID}}'"`
  run bash -c "docker images graze/php-alpine --format '{{.ID}} ({{.Tag}})' | grep $id"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [[ "$output" == *"(7.4"* ]]

  [[ "$output" == *"(7)"* ]]
  [[ "$output" != *"(latest)"* ]]

  [[ "$output" != *"(7-test)"* ]]
  [[ "$output" != *"(7.4-test)"* ]]
  [[ "$output" != *"(test)"* ]]
}

@test "the test tags are created" {
  id=`bash -c "docker images graze/php-alpine:7.4-test --format '{{.ID}}'"`
  run bash -c "docker images graze/php-alpine --format '{{.ID}} ({{.Tag}})' | grep $id"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [[ "$output" == *"(7.4-test)"* ]]

  [[ "$output" == *"(7-test)"* ]]
  [[ "$output" != *"(test)"* ]]

  [[ "$output" != *"(7)"* ]]
  [[ "$output" != *"(7.1)"* ]]
  [[ "$output" != *"(latest)"* ]]
}
