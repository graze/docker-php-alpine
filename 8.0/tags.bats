#!/usr/bin/env bats

@test "the main tags are created" {
  run bash -c "docker images graze/php-alpine --format '{{.ID}} ({{.Tag}})' | grep "$(docker images graze/php-alpine:8.0 --format '{{.ID}}')""
  echo 'output:' $output
  [[ "$output" == *"(8.0)"* ]]
}

@test "the test tags are created" {
  run bash -c "docker images graze/php-alpine --format '{{.ID}} ({{.Tag}})' | grep "$(docker images graze/php-alpine:8.0-test --format '{{.ID}}')""
  echo 'output:' $output
  [[ "$output" == *"(8.0-test)"* ]]
}
