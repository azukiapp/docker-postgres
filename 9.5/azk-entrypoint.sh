#!/bin/bash
set -e

export POSTGRES_PASS="${POSTGRES_PASS:-$POSTGRESQL_PASS}"
export POSTGRES_USER="${POSTGRES_USER:-$POSTGRESQL_USER}"
export   POSTGRES_DB="${POSTGRES_DB:-$POSTGRESQL_DB}"

exec /docker-entrypoint.sh "$@"
