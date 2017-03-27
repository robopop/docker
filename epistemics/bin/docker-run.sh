#!/bin/bash

set -e -x

BIN="$(cd "$(dirname "$0")" ; pwd)"
PROJECT="$(dirname "${BIN}")"

docker rm -f epistemics || true
docker rm -f epistemics-mysql || true

"${BIN}/create-db-user.sh"

docker run --name 'epistemics' -p 8888:8080 -d -v "$PROJECT/data/selemca:/usr/local/selemca" --link epistemics-mysql jeroenvm/epistemics

sleep 10
docker logs epistemics
