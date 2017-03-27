#!/bin/bash

set -e -x

BIN="$(cd "$(dirname "$0")" ; pwd)"
PROJECT="$(dirname "${BIN}")"

function remove-container() {
	local NAME="$1"
	local RUNNING_FLAG="$(docker inspect --format '{{.State.Running}}' "${NAME}" 2>/dev/null || true)"
	if [ -n "${RUNNING_FLAG}" ]
	then
       		if "${RUNNING_FLAG}"
		then
			docker stop "${NAME}"
		fi
		docker rm "${NAME}"
	fi
}

remove-container epistemics
remove-container epistemics-mysql

"${BIN}/create-db-user.sh"

docker run --name 'epistemics' -p 8888:8080 -d -v "$PROJECT/data/selemca:/usr/local/selemca" --link epistemics-mysql jeroenvm/epistemics

sleep 10
docker logs epistemics
