#!/usr/bin/env bats

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
  [[ "${output}" == *Core* ]]
  [[ "${output}" == *ctype* ]]
  [[ "${output}" == *curl* ]]
  [[ "${output}" == *date* ]]
  [[ "${output}" == *dom* ]]
  [[ "${output}" == *ereg* ]]
  [[ "${output}" == *event* ]]
  [[ "${output}" == *fileinfo* ]]
  [[ "${output}" == *filter* ]]
  [[ "${output}" == *hash* ]]
  [[ "${output}" == *iconv* ]]
  [[ "${output}" == *intl* ]]
  [[ "${output}" == *json* ]]
  [[ "${output}" == *libxml* ]]
  [[ "${output}" == *mbstring* ]]
  [[ "${output}" == *memcached* ]]
  [[ "${output}" == *mysqli* ]]
  [[ "${output}" == *mysqlnd* ]]
  [[ "${output}" == *openssl* ]]
  [[ "${output}" == *pcre* ]]
  [[ "${output}" == *pcntl* ]]
  [[ "${output}" == *PDO* ]]
  [[ "${output}" == *pdo_mysql* ]]
  [[ "${output}" == *pdo_pgsql* ]]
  [[ "${output}" == *pdo_sqlite* ]]
  [[ "${output}" == *pgsql* ]]
  [[ "${output}" == *Phar* ]]
  [[ "${output}" == *posix* ]]
  [[ "${output}" == *readline* ]]
  [[ "${output}" == *Reflection* ]]
  [[ "${output}" == *session* ]]
  [[ "${output}" == *SimpleXML* ]]
  [[ "${output}" == *soap* ]]
  [[ "${output}" == *sockets* ]]
  [[ "${output}" == *SPL* ]]
  [[ "${output}" == *standard* ]]
  [[ "${output}" == *tokenizer* ]]
  [[ "${output}" == *xml* ]]
  [[ "${output}" == *xmlreader* ]]
  [[ "${output}" == *xmlwriter* ]]
  [[ "${output}" == *yaml* ]]
  [[ "${output}" == *"Zend OPcache"* ]]
  [[ "${output}" == *zip* ]]
  [[ "${output}" == *zlib* ]]
}
