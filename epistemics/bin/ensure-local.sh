#!/bin/bash

BIN="$(cd "$(dirname "$0")" ; pwd)"
PROJECT="$(dirname "${BIN}")"

function ensure-local-file() {
    local SAMPLE_FILE="$*"
    local LOCAL_FILE="$(echo "${SAMPLE_FILE}" | sed -e 's/-sample/-local/')"
    local ACTION="untouched"
    if [ -e "${LOCAL_FILE}" ]
    then
        :
    else
        cp "${SAMPLE_FILE}" "${LOCAL_FILE}"
        ACTION="copied from ${SAMPLE_FILE}"
    fi
    echo "Ensure local: ${LOCAL_FILE}: ${ACTION}" >&2
}

(
    echo "Ensure local: $(pwd)" >&2
    cd "${PROJECT}"
    /usr/bin/find "." -name '*-sample.*' -o -name '*-sample' \
        | while read FILE
            do
                ensure-local-file "${FILE}"
            done
)
