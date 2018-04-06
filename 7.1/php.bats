#!/usr/bin/env bats

readonly container="graze/php-alpine:7.1"

@test "php version is correct" {
  run docker run --rm ${container} php -v
  echo 'status:' $status
  echo 'output:' $output
  version="$(echo $output | sed 's/.*PHP \([0-9].[0-9]\).*/\1/')"
  echo 'version:' $version
  [ "$status" -eq 0 ]
  [[ "$version" == "7.1" ]]
}

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

@test "the image has the correct php modules installed" {
  run docker run --rm ${container} php -m
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [[ "${output}" == *"apcu"* ]]
  [[ "${output}" == *"bcmath"* ]]
  [[ "${output}" == *"Core"* ]]
  [[ "${output}" == *"ctype"* ]]
  [[ "${output}" == *"curl"* ]]
  [[ "${output}" == *"date"* ]]
  [[ "${output}" == *"dom"* ]]
  [[ "${output}" == *"event"* ]]
  [[ "${output}" == *"fileinfo"* ]]
  [[ "${output}" == *"filter"* ]]
  [[ "${output}" == *"hash"* ]]
  [[ "${output}" == *"iconv"* ]]
  [[ "${output}" == *"intl"* ]]
  [[ "${output}" == *"json"* ]]
  [[ "${output}" == *"libxml"* ]]
  [[ "${output}" == *"mbstring"* ]]
  [[ "${output}" == *"mcrypt"* ]]
  [[ "${output}" == *"memcached"* ]]
  [[ "${output}" == *"mysqli"* ]]
  [[ "${output}" == *"mysqlnd"* ]]
  [[ "${output}" == *"openssl"* ]]
  [[ "${output}" == *"pcre"* ]]
  [[ "${output}" == *"pcntl"* ]]
  [[ "${output}" == *"PDO"* ]]
  [[ "${output}" == *"pdo_mysql"* ]]
  [[ "${output}" == *"pdo_pgsql"* ]]
  [[ "${output}" == *"pdo_sqlite"* ]]
  [[ "${output}" == *"pgsql"* ]]
  [[ "${output}" == *"Phar"* ]]
  [[ "${output}" == *"posix"* ]]
  [[ "${output}" == *"readline"* ]]
  [[ "${output}" == *"Reflection"* ]]
  [[ "${output}" == *"session"* ]]
  [[ "${output}" == *"SimpleXML"* ]]
  [[ "${output}" == *"soap"* ]]
  [[ "${output}" == *"sockets"* ]]
  [[ "${output}" == *"SPL"* ]]
  [[ "${output}" == *"standard"* ]]
  [[ "${output}" == *"tokenizer"* ]]
  [[ "${output}" == *"xml"* ]]
  [[ "${output}" == *"xmlreader"* ]]
  [[ "${output}" == *"xmlwriter"* ]]
  [[ "${output}" == *"yaml"* ]]
  [[ "${output}" == *"Zend OPcache"* ]]
  [[ "${output}" == *"zip"* ]]
  [[ "${output}" == *"zlib"* ]]
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
