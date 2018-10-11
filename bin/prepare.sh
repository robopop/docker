#!/usr/bin/env bash

BIN="$(cd "$(dirname "$0")" ; pwd)"
PROJECT="$(dirname "${BIN}")"

source "${BIN}/verbose.sh"

function robopop-stop() {
    (
      cd "${PROJECT}/robopop"
      docker-compose stop
    )
}

robopop-stop

docker run \
    --rm \
    -v robopop_epistemics-config:/usr/local/selemca \
    -v "${PROJECT}:${PROJECT}" \
    -w "${PROJECT}" \
    cfmanteiga/alpine-bash-curl-jq bash -c '(
  pwd
  bin/create-local-settings.sh
  cp epistemics/data/selemca/* /usr/local/selemca/.
)'

( "${PROJECT}/robopop/docker-compose-up.sh" > /dev/null 2>&1 ) &

function isUp() {
    docker run --rm --network robopop_robopop cfmanteiga/alpine-bash-curl-jq bash -c '(
  set -x
  curl -sS -D - http://epistemics:8080/beliefsystem-rest/epistemics/context
)'
}

function stillWaiting() {
  if isUp
  then
    return 1
  else
    return 0
  fi
}

N=0
while [ "${N}" -lt 30 ] && stillWaiting
do
  echo -n '.'
  sleep 0.5
  N=$[${N} + 1]
done
echo

docker run \
    --rm \
    -v "${PROJECT}:${PROJECT}" \
    -w "${PROJECT}" \
    --network robopop_robopop \
    cfmanteiga/alpine-bash-curl-jq bash -c 'robopop/load-default-data.sh http://epistemics:8080'

robopop-stop
