#!/bin/bash

set -e

SED_EXT=-r
case $(uname) in
Darwin*)
        SED_EXT=-E
esac
export SED_EXT

COMPOSE="$(cd "$(dirname "$0")" ; pwd)"
DOCKER="$(dirname "${COMPOSE}")"
EPISTEMICS="${DOCKER}/epistemics"
SILICON_COPPELIA="${DOCKER}/sico"

. "${DOCKER}/bin/verbose.sh"

source "${COMPOSE}/etc/settings-local.sh"
source "${EPISTEMICS}/etc/settings-local.sh"
source "${EPISTEMICS}/etc/credentials-local.sh"
source "${SILICON_COPPELIA}/etc/settings-local.sh"

BASE="${COMPOSE}/docker-compose"
TEMPLATE="${BASE}-template.yml"
TARGET="${BASE}.yml"
SICO_SUFFIX=''
: ${DISPLAY:=172.16.123.1:0}
if [ ".$1" = '.--gui' ]
then
    SICO_SUFFIX='-gui'
    shift
    if [ ".$1" = '.-d' ]
    then
        export DISPLAY="$2"
        shift 2
    fi
fi
VARIABLES="$(tr '$\012' '\012$' < "${TEMPLATE}" | sed -e '/^[{][A-Za-z_][A-Za-z0-9_]*[}]/!d' -e 's/^[{]//' -e 's/[}].*//')"

function re-protect() {
    sed "${SED_EXT}" -e 's/([[]|[]]|[|*?^$()/])/\\\1/g'
}

function substitute() {
    local VARIABLE="$1"
    local VALUE="$(eval "echo \"\${${VARIABLE}}\"" | re-protect)"
    log "VALUE=[${VALUE}]"
    if [ -n "$(eval "echo \"\${${VARIABLE}+true}\"")" ]
    then
        sed "${SED_EXT}" -e "s/[\$][{]${VARIABLE}[}]/${VALUE}/g" "${TARGET}" > "${TARGET}~"
        mv "${TARGET}~" "${TARGET}"
    fi
}

cp "${TEMPLATE}" "${TARGET}"
for VARIABLE in ${VARIABLES}
do
    log "VARIABLE=[${VARIABLE}]"
    substitute "${VARIABLE}"
done
"${SILENT}" || diff "${TEMPLATE}" "${TARGET}" || true

docker-compose up
