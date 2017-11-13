#!/bin/bash

set -e -x

BIN="$(cd "$(dirname "$0")" ; pwd)"
PROJECT="$(dirname "${BIN}")"

VERSION='1.3.0-SNAPSHOT'
ARTIFACTORY_IP="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' artifactory 2>/dev/null || true)"
ARTIFACTORY_URL=''
if [ -n "${ARTIFACTORY_IP}" ]
then
	ARTIFACTORY_URL="http://${ARTIFACTORY_IP}:8081/artifactory/libs-release-local/selemca"
fi
LOCAL_REPO="${HOME}/.m2/repository"

function download-artifact() {
	local ARTIFACT_ID="$1"
	local PACKAGE_ID="$2"
	local VERSION="$3"
	if [ -n "${ARTIFACTORY_URL}" ]
	then
		curl -L -sS -o "${PACKAGE_ID}" "${ARTIFACTORY_URL}/${ARTIFACT_ID}/${PACKAGE_ID}"
	elif [ -d "${LOCAL_REPO}" ]
	then
		cp "${LOCAL_REPO}/selemca/${ARTIFACT_ID}/${PACKAGE_ID}" "${PACKAGE_ID}"
	else
		return 1
	fi
}

(
	cd "${PROJECT}/docker"

	download-artifact "epistemics-beliefsystem-rest/${VERSION}" "epistemics-beliefsystem-rest-${VERSION}.war" "${VERSION}"
	download-artifact "epistemics-beliefsystem-webadmin/${VERSION}" "epistemics-beliefsystem-webadmin-${VERSION}.war" "${VERSION}"
	download-artifact "epistemics-mentalworld-webapp/${VERSION}" "epistemics-mentalworld-webapp-${VERSION}.war" "${VERSION}"
	download-artifact "epistemics-mentalworld-webadmin/${VERSION}" "epistemics-mentalworld-webadmin-${VERSION}.war" "${VERSION}"
	download-artifact "epistemics-mentalworld-rest/${VERSION}" "epistemics-mentalworld-rest-${VERSION}.war" "${VERSION}"

	docker build -t jeroenvm/epistemics .
)
