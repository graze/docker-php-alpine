#!/usr/bin/env bats

@test "the main tags are created" {
  run bash -c "docker images graze/php-alpine --format '{{.ID}} ({{.Tag}})' | grep "$(docker images graze/php-alpine:8.5 --format '{{.ID}}')""
  echo 'output:' $output
  [[ "$output" == *"(8.5)"* ]]
  [[ "$output" == *"(8)"* ]]
  [[ "$output" == *"(latest)"* ]]
}

@test "the test tags are created" {
  run bash -c "docker images graze/php-alpine --format '{{.ID}} ({{.Tag}})' | grep "$(docker images graze/php-alpine:8.5-test --format '{{.ID}}')""
  echo 'output:' $output
  [[ "$output" == *"(8.5-test)"* ]]
  [[ "$output" == *"(8-test)"* ]]
  [[ "$output" == *"(test)"* ]]
}
