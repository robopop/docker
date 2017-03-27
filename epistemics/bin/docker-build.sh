#!/bin/bash

## /artifactory/libs-release-local/selemca/epistemics-beliefsysteem-rest/1.2/epistemics-beliefsysteem-rest-1.2.war

set -e -x

BIN="$(cd "$(dirname "$0")" ; pwd)"
PROJECT="$(dirname "${BIN}")"

VERSION='1.2'
ARTIFACTORY_IP="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' artifactory)"
ARTIFACTORY_URL="http://${ARTIFACTORY_IP}:8081/artifactory/libs-release-local/selemca"

function download-artifact() {
	local ARTIFACT_ID="$1"
	local PACKAGE_ID="$2"
	curl -L -sS -o "${PACKAGE_ID}" "${ARTIFACTORY_URL}/${ARTIFACT_ID}/${PACKAGE_ID}"
}

(
	cd "${PROJECT}/docker"

	download-artifact "epistemics-beliefsysteem-rest/${VERSION}" "epistemics-beliefsysteem-rest-${VERSION}.war"
	download-artifact "epistemics-beliefsystem-webadmin/${VERSION}" "epistemics-beliefsystem-webadmin-${VERSION}.war"
	download-artifact "epistemics-mentalworld-webapp/${VERSION}" "epistemics-mentalworld-webapp-${VERSION}.war"
	download-artifact "epistemics-mentalworld-webadmin/${VERSION}" "epistemics-mentalworld-webadmin-${VERSION}.war"

	docker build -t jeroenvm/epistemics .
)
