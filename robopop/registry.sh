#!/usr/bin/env bash

set -e

SED_EXT=-r
case $(uname) in
Darwin*)
        SED_EXT=-E
esac
export SED_EXT

COMPOSE="$(cd "$(dirname "$0")" ; pwd)"
DOCKER="$(dirname "${COMPOSE}")"
DOCKER_REPOSITORY='robopop'
EPISTEMICS="${DOCKER}/epistemics"
SILICON_COPPELIA="${DOCKER}/sico"

: ${SILENT:=true}
source "${DOCKER}/bin/verbose.sh"

: ${EPISTEMICS_IMAGE_VERSION:=latest}
: ${SICO_IMAGE_VERSION:=latest}
source "${COMPOSE}/etc/settings-local.sh"
source "${EPISTEMICS}/etc/settings-local.sh"
source "${SILICON_COPPELIA}/etc/settings-local.sh"

IMG_EPISTEMICS="epistemics:${EPISTEMICS_IMAGE_VERSION}"
IMG_SICO="silicon-coppelia:${SICO_IMAGE_VERSION}"
IMG_SICO_GUI="silicon-coppelia-gui:${SICO_IMAGE_VERSION}"

function glob-to-basic-re() {
    echo "$@" | sed "${SED_EXT}" -e 's/([.^$\\])/\\\1/' -e 's/[?]/./' -e 's/[*]/.*/' -e 's/^/^/' -e 's/$/$/'
}

REMOTE_REPOSITORY="${DOCKER_REPOSITORY}"
if [ ".$1" = '.-r' -o ".$1" = '--remote' ]
then
    REMOTE_REPOSITORY="$2"
    shift 2
fi

ACTION="$1" ; shift
PATTERN="$1" ; shift || true

if [ -z "${PATTERN}" ]
then
    PATTERN='*'
fi
PATTERN_RE="$(glob-to-basic-re "${PATTERN}")"
log "PATTERN_RE=[${PATTERN_RE}]"

function include-image() {
    echo "$@" | grep "${PATTERN_RE}"
}

function part() {
    local INDEX="$1" ; shift
    echo "$@" | cut -d : -f "${INDEX}"
}

function fix-tag() {
    local NAME="$1" ; shift
    local TAG="$1" ; shift
}

function registry-push() {
    local NAME="$1" ; shift
    local TAG="$1" ; shift
    local TARGET="${REMOTE_REPOSITORY}/${NAME}:${TAG}"
    info "Pushing: ${NAME}:${TAG} to ${REMOTE_REPOSITORY}"
    if [ ".${DOCKER_REPOSITORY}" != ".${REMOTE_REPOSITORY}" ]
    then
        docker tag "${DOCKER_REPOSITORY}/${NAME}:${TAG}" "${TARGET}"
    fi
    docker push "${TARGET}"
}

function registry-pull() {
    local NAME="$1" ; shift
    local TAG="$1" ; shift
    local SOURCE="${REMOTE_REPOSITORY}/${NAME}:${TAG}"
    info "Pulling: ${NAME}:${TAG} from ${REMOTE_REPOSITORY}"
    docker pull "${SOURCE}"
    if [ ".${DOCKER_REPOSITORY}" != ".${REMOTE_REPOSITORY}" ]
    then
        docker tag "${SOURCE}" "${DOCKER_REPOSITORY}/${NAME}:${TAG}"
    fi
}

for IMAGE in "${IMG_EPISTEMICS}" "${IMG_SICO}" "${IMG_SICO_GUI}"
do
    NAME="$(part 1 "${IMAGE}")"
    TAG="$(part 2 "${IMAGE}")"
    if include-image "${NAME}"
    then
        case "${ACTION}" in
        push)
            registry-push "${NAME}" "${TAG}"
            ;;
        pull)
            registry-pull "${NAME}" "${TAG}"
            ;;
        *)
            error "Unknown action: [${ACTION}]"
            exit 1
        esac
    else
        log "Skipped: ${IMAGE}"
    fi
done
