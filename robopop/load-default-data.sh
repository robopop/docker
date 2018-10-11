#!/usr/bin/env bash

ROBOPOP="$(cd "$(dirname "$0")" ; pwd)"
PROJECT="$(dirname "${ROBOPOP}")"
TMP="${PROJECT}/data/tmp"

EPISTEMICS_BASE_URL='http://localhost:8888'

if [ -n "$1" ]
then
  EPISTEMICS_BASE_URL="$1" ; shift
fi

mkdir -p "${TMP}"

curl -L -sS -D - 'https://github.com/robopop/epistemics/raw/master/Installation/BeliefSystem.zip' -o "${TMP}/BeliefSystem-curl.zip"

curl -sS -D - -X POST -F "file=@${TMP}/BeliefSystem-curl.zip" "${EPISTEMICS_BASE_URL}/beliefsystem-rest/epistemics/belief-system"