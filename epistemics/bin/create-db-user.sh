#!/bin/bash

set -e -x

BIN="$(cd "$(dirname "$0")" ; pwd)"
PROJECT="$(dirname "${BIN}")"
ETC="${PROJECT}/etc"

function try-sql() {
	echo "$@" | docker exec -i 'epistemics-mysql' mysql -pwortel
}
function do-sql() {
	try-sql "$@" || true
}

function check-not-empty() {
    local VALUE="$(eval echo "\${$1}")"
    if [ -z "${VALUE}" ]
    then
        echo "Missing value for: $1" >&2
        exit 1
    fi
}

"${BIN}/ensure-local.sh"
. "${ETC}/settings-local.sh"
. "${ETC}/credentials-local.sh"

check-not-empty DB_USER
check-not-empty DB_PASSWORD
check-not-empty DB_ROOT_PASSWORD
check-not-empty DB_SCHEMA

sed \
    -e "s/\\\${DB_USER}/${DB_USER}/" \
    -e "s/\\\${DB_PASSWORD}/${DB_PASSWORD}/" \
    -e "s/\\\${DB_ROOT_PASSWORD}/${DB_ROOT_PASSWORD}/" \
    -e "s/\\\${DB_SCHEMA}/${DB_SCHEMA}/" \
    "${ETC}/database-template.properties" \
    > "${PROJECT}/data/selemca/database.properties"

docker rm -f epistemics-mysql || true

docker run --name 'epistemics-mysql' -d --env "MYSQL_ROOT_PASSWORD=${DB_ROOT_PASSWORD}" -v "$PROJECT/data/mysql:/var/lib/mysql" mysql:5.6

N=60
while ! try-sql 'show databases;' && [ "${N}" -gt 0 ]
do
	N=$[$N-1]
	sleep 1
done

do-sql "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';"
do-sql "CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';"
do-sql "CREATE DATABASE ${DB_SCHEMA};"
do-sql "GRANT ALL PRIVILEGES ON ${DB_SCHEMA}.* TO '${DB_USER}'@'localhost';"
do-sql "GRANT ALL PRIVILEGES ON ${DB_SCHEMA}.* TO '${DB_USER}'@'%';"
do-sql "FLUSH PRIVILEGES;"
do-sql "show databases;"
