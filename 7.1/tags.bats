#!/usr/bin/env bats

@test "the main tags are created" {
  id=`bash -c "docker images graze/php-alpine:7.1 --format '{{.ID}}'"`
  run bash -c "docker images graze/php-alpine --format '{{.ID}} ({{.Tag}})' | grep $id"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [[ "$output" == *"(7.1"* ]]
  [[ "$output" == *"(7.1-"[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]")"* ]]

  [[ "$output" != *"(7)"* ]]
  [[ "$output" != *"(7-"[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]")"* ]]
  [[ "$output" != *"(latest)"* ]]

  [[ "$output" != *"(7-test)"* ]]
  [[ "$output" != *"(7.1-test)"* ]]
  [[ "$output" != *"(7-test-"[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]")"* ]]
  [[ "$output" != *"(7.1-test-"[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]")"* ]]
  [[ "$output" != *"(test)"* ]]
}

@test "the test tags are created" {
  id=`bash -c "docker images graze/php-alpine:7.1-test --format '{{.ID}}'"`
  run bash -c "docker images graze/php-alpine --format '{{.ID}} ({{.Tag}})' | grep $id"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [[ "$output" == *"(7.1-test)"* ]]
  [[ "$output" == *"(7.1-test-"[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]")"* ]]

  [[ "$output" != *"(7-test)"* ]]
  [[ "$output" != *"(7-test-"[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]")"* ]]
  [[ "$output" != *"(test)"* ]]

  [[ "$output" != *"(7)"* ]]
  [[ "$output" != *"(7.1)"* ]]
  [[ "$output" != *"(7-"[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]")"* ]]
  [[ "$output" != *"(7.1-"[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]")"* ]]
  [[ "$output" != *"(latest)"* ]]
}
