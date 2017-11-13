#!/bin/bash

set -e

BIN="$(cd "$(dirname "$0")" ; pwd)"
DOCKER="$(dirname "${BIN}")"
EPISTEMICS="${DOCKER}/epistemics"

. "${DOCKER}/bin/verbose.sh"

(
    cd "${EPISTEMICS}/data/selemca"
    docker run -v robopop_epistemics-config:/usr/local/selemca --name helper busybox true
    docker cp . helper:/usr/local/selemca
    docker rm helper
)
