#!/usr/bin/env bash

USER="--user $(id -u):$(id -g)"
CACHE_DIR="--volume $(pwd)/../composer_cache:/tmp"

docker run \
  --rm \
  ${USER} \
  ${CACHE_DIR} \
  -v $(pwd):/app \
    composer create-project symfony/skeleton tester

exit $?