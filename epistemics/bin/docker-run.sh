#!/bin/bash

set -e -x

BIN="$(cd "$(dirname "$0")" ; pwd)"
PROJECT="$(dirname "${BIN}")"
ETC="${PROJECT}/etc"

. "${BIN}/lib.sh"
"${BIN}/ensure-local.sh"
. "${ETC}/settings-local.sh"

check-not-empty SERVER_PORT

docker rm -f epistemics || true
docker rm -f epistemics-mysql || true

"${BIN}/create-db-user.sh"

docker run --name 'epistemics' -p "${SERVER_PORT}:8080" -d -v "$PROJECT/data/selemca:/usr/local/selemca" --link epistemics-mysql jeroenvm/epistemics

sleep 10
docker logs epistemics
