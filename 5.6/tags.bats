#!/usr/bin/env bats

@test "the main tags are created" {
  id=`bash -c "docker images graze/php-alpine:5.6 --format '{{.ID}}'"`
  run bash -c "docker images graze/php-alpine --format '{{.ID}} ({{.Tag}})' | grep $id"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [[ "$output" == *"(5)"* ]]
  [[ "$output" == *"(5.6)"* ]]
  [[ "$output" != *"(latest)"* ]]

  [[ "$output" != *"(5-test)"* ]]
  [[ "$output" != *"(5.6-test)"* ]]
  [[ "$output" != *"(test)"* ]]
}

@test "the test tags are created" {
  id=`bash -c "docker images graze/php-alpine:5.6-test --format '{{.ID}}'"`
  run bash -c "docker images graze/php-alpine --format '{{.ID}} ({{.Tag}})' | grep $id"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [[ "$output" == *"(5-test)"* ]]
  [[ "$output" == *"(5.6-test)"* ]]
  [[ "$output" != *"(test)"* ]]

  [[ "$output" != *"(5)"* ]]
  [[ "$output" != *"(5.6)"* ]]
  [[ "$output" != *"(latest)"* ]]
}
