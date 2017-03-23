#!/usr/bin/env bats

readonly container="graze/php-alpine:7.1-debug"

@test "php version is correct" {
  run docker run --rm ${container} php -v
  echo 'status:' $status
  echo 'output:' $output
  version="$(echo $output | sed 's/.*PHP \([0-9].[0-9]\).*/\1/')"
  echo 'version:' $version
  [ "$status" -eq 0 ]
  [[ "$version" == "7.1" ]]
}

@test "the image has the correct php modules installed" {
  run docker run --rm ${container} php -m
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [[ "${output}" == *apcu* ]]
  [[ "${output}" == *bcmath* ]]
  [[ "${output}" == *curl* ]]
  [[ "${output}" == *dom* ]]
  [[ "${output}" == *exif* ]]
  [[ "${output}" == *gd* ]]
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
  [[ "${output}" == *phpdbg* ]]
  [[ "${output}" == *pdo* ]]
  [[ "${output}" == *pdo_mysql* ]]
  [[ "${output}" == *pdo_pgsql* ]]
  [[ "${output}" == *pdo_sqllite* ]]
  [[ "${output}" == *pgsql* ]]
  [[ "${output}" == *soap* ]]
  [[ "${output}" == *sockets* ]]
  [[ "${output}" == *xml* ]]
  [[ "${output}" == *xml_reader* ]]
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