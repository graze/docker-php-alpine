#!/usr/bin/env bats

readonly container="graze/php-alpine:5.6"

@test "php version is correct" {
  run docker run --rm ${container} php -v
  echo 'status:' $status
  echo 'output:' $output
  version="$(echo $output | sed 's/.*PHP \([0-9].[0-9]\).*/\1/')"
  echo 'version:' $version
  [ "$status" -eq 0 ]
  [[ "$version" == "5.6" ]]
}

@test "the image has the correct php modules installed" {
  run docker run --rm ${container} php -m
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [[ "${output}" == *bcmath* ]]
  [[ "${output}" == *curl* ]]
  [[ "${output}" == *dom* ]]
  [[ "${output}" == *iconv* ]]
  [[ "${output}" == *intl* ]]
  [[ "${output}" == *json* ]]
  [[ "${output}" == *mbstring* ]]
  [[ "${output}" == *mcrypt* ]]
  [[ "${output}" == *memcache* ]]
  [[ "${output}" == *memcached* ]]
  [[ "${output}" == *mysql* ]]
  [[ "${output}" == *mysqli* ]]
  [[ "${output}" == *openssl* ]]
  [[ "${output}" == *pdo* ]]
  [[ "${output}" == *pdo_mysql* ]]
  [[ "${output}" == *pdo_pgsql* ]]
  [[ "${output}" == *pdo_sqlite* ]]
  [[ "${output}" == *pgsql* ]]
  [[ "${output}" == *soap* ]]
  [[ "${output}" == *sockets* ]]
  [[ "${output}" == *xml* ]]
  [[ "${output}" == *xmlreader* ]]
  [[ "${output}" == *yaml* ]]
  [[ "${output}" == *zip* ]]
  [[ "${output}" == *zlib* ]]
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
