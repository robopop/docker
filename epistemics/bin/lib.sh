#!/usr/bin/false

function check-not-empty() {
    local VALUE="$(eval echo "\${$1}")"
    if [ -z "${VALUE}" ]
    then
        echo "Missing value for: $1" >&2
        exit 1
    fi
}
