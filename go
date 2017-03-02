#!/bin/bash

set -eu

export VAULT_TOKEN="token"
export VAULT_ADDR="http://localhost:18200"

function ensure_teardown {
  docker-compose kill
  docker-compose rm -f
}

function task_run {
  trap ensure_teardown INT TERM EXIT

  docker-compose up -d vault
  vault token-create \
    -id=renewable \
    -renewable=true \
    -ttl=1m \
    -policy=root

  vault write \
    /secret/some/secret \
    output="not secret" \
    ttl=1m

  docker-compose up consul-template
}

function task_build {
  docker build -t consul-template .
}

function task_build_mh {
  embedmd markdown.md > markdown.md.gen
}

function task_write_secret {
  local path="$1"
  local secret="$2"

  VAULT_ADDR="http://localhost:18200"
  VAULT_TOKEN="token"

  vault write "${1}" "${2}" ttl=1m
}

function task_usage {
    echo "Usage: $0 build | build_md | run | write_secret"
    exit 1
}

CMD=${1:-}
shift || true
case ${CMD} in
  build) task_build ;;
  build_md) task_build_mh ;;
  run) task_run ;;
  write_secret) task_write_secret "$@" ;;
  *) task_usage ;;
esac
