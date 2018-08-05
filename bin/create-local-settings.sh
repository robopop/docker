#!/bin/bash

set -e

BIN="$(cd "$(dirname "$0")" ; pwd)"
PROJECT="$(dirname "${BIN}")"

declare -a FLAGS_INHERIT
. "${BIN}/verbose.sh"

QUALIFIER="$1" ; shift || true

info "PROJECT=[${PROJECT}]"

function visit-samples() {
    local PATTERN="$1" ; shift
    find "${PROJECT}" -name "${PATTERN}" -print0 | xargs -0 -n 1 "${BIN}/create-local-setting.sh" "${FLAGS_INHERIT[@]}" "$@"
}

if [ -n "${QUALIFIER}" ]
then
    info "QUALIFIER=[${QUALIFIER}]"
    visit-samples "*-sample+${QUALIFIER}.*"
fi

visit-samples '*-sample.*'
