#!/bin/bash

BIN="$(cd "$(dirname "$0")" ; pwd)"
DOCKER="$(dirname "${BIN}")"
EPISTEMICS="${DOCKER}/epistemics"

(
    cd "${EPISTEMICS}/data/selemca"
    docker run -v stack_epistemics-config:/usr/local/selemca --name helper busybox true
    docker cp . helper:/usr/local/selemca
    docker rm helper
)
