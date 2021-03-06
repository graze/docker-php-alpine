#!/usr/bin/env bats

@test "the image has a MIT license" {
  run bash -c "docker inspect ${container} | jq -r '.[].Config.Labels.license'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" = "MIT" ]
}

@test "the image has a maintainer" {
  run bash -c "docker inspect ${container} | jq -r '.[].Config.Labels.maintainer'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" = "developers@graze.com" ]
}

@test "the image uses label-schema.org" {
  run bash -c "docker inspect ${container} | jq -r '.[].Config.Labels.\"org.label-schema.schema-version\"'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" = "1.0" ]
}

@test "the image has a vcs-url label" {
  run bash -c "docker inspect ${container} | jq -r '.[].Config.Labels.\"org.label-schema.vcs-url\"'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" = "https://github.com/graze/docker-php-alpine" ]
}

@test "the image has a vcs-ref label set to the current head commit in github" {
  run bash -c "docker inspect ${container} | jq -r '.[].Config.Labels.\"org.label-schema.vcs-ref\"'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" = `git rev-parse --short HEAD` ]
}

@test "the image has a build-date label" {
  run bash -c "docker inspect ${container} | jq -r '.[].Config.Labels.\"org.label-schema.build-date\"'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" != "null" ]
}

@test "the image has a vendor label" {
  run bash -c "docker inspect ${container} | jq -r '.[].Config.Labels.\"org.label-schema.vendor\"'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" = "graze" ]
}

@test "the image has a name label" {
  run bash -c "docker inspect ${container} | jq -r '.[].Config.Labels.\"org.label-schema.name\"'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" = "php-alpine" ]
}

@test "the image does not return any warnings" {
  run docker run ${container} php -m
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [[ "${output}" != *"PHP Warning"* ]]
  [[ "${output}" != *"PHP Notice"* ]]
}

@test "the image has an empty entrypoint" {
  run bash -c "docker inspect ${container} | jq -r '.[]?.Config.Entrypoint[]?'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" = "" ]
}

@test "php should have a memory limit of 1024M" {
  run bash -c "docker run --rm ${container} php -i | grep memory_limit"
  echo "status: $status"
  echo "output: $output"
  [ "$status" -eq 0 ]
  [ "$output" = "memory_limit => 1024M => 1024M" ]
}

@test "the image uses a fixed iconv module" {
  run bash -c "docker inspect ${container} | jq -r '.[]?.Config.Env[]'"
  echo "status: $status"
  echo "output: $output"
  [ "$status" -eq 0 ]
  [[ "${output}" == *"LD_PRELOAD=/usr/lib/preloadable_libiconv.so php"* ]]
}

@test "iconv works" {
  run docker run ${container} php -r 'echo iconv("UTF-8", "ASCII//TRANSLIT", "foobar");'
  echo "status: $status"
  echo "output: $output"
  [ "$status" -eq 0 ]
  [ "$output" = "foobar" ]
  [[ "${output}" != *"PHP Notice"* ]]
}

@test "the image has curl installed" {
  run docker run --rm --entrypoint=/bin/sh ${container} -c '[ -x /usr/bin/curl ]'
  echo 'status:' $status
  [ "$status" -eq 0 ]
}

@test "short open tag enabled" {
  run bash -c "docker run ${container} php -i | grep -w short_open_tag"
  echo "status: $status"
  echo "output: $output"
  [ "$status" -eq 0 ]
  [ "$output" == "short_open_tag => On => On" ]
}
