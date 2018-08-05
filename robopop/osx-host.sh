#!/usr/bin/env bash

function get-host() {
    ifconfig lo0 | sed -n -e '/inet 127[.]0[.]0[.]1 /d' -e 's/ netmask .*//' -e 's/^.*inet //p' | head -1
}

HOST="$(get-host)"
if [ -z "${HOST}" ]
then
    sudo ifconfig lo0 alias 172.16.123.1
    HOST="$(get-host)"
fi

if [ -n "${HOST}" ]
then
    xhost "${HOST}" >/dev/null 2>&1
    echo "${HOST}"
fi
