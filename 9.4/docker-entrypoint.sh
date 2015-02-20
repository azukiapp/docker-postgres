#!/bin/bash
set -e

if [ "$1" = 'postgres' ]; then
	chown -R postgres "$PGDATA"

	if [ -z "$(ls -A "$PGDATA")" ]; then
		gosu postgres initdb

		sed -ri "s/^#(listen_addresses\s*=\s*)\S+/\1'*'/" "$PGDATA"/postgresql.conf

		# check password first so we can ouptut the warning before postgres
		# messes it up
		if [ "$POSTGRESQL_PASS" ]; then
			pass="PASSWORD '$POSTGRESQL_PASS'"
			authMethod=md5
		else
			# The - option suppresses leading tabs but *not* spaces. :)
			cat >&2 <<-'EOWARN'
				****************************************************
				WARNING: No password has been set for the database.
								 This will allow anyone with access to the
								 Postgres port to access your database. In
								 Docker's default configuration, this is
								 effectively any other container on the same
								 system.

								 Use "-e POSTGRESQL_PASS=password" to set
								 it in "docker run".
				****************************************************
			EOWARN

			pass=
			authMethod=trust
		fi

		: ${POSTGRESQL_USER:=postgres}
		if [ "$POSTGRESQL_USER" = 'postgres' ]; then
			op='ALTER'
		else
			op='CREATE'
			gosu postgres postgres --single -jE <<-EOSQL
				CREATE DATABASE "$POSTGRESQL_USER" ;
			EOSQL
			echo
		fi

		gosu postgres postgres --single -jE <<-EOSQL
			$op USER "$POSTGRESQL_USER" WITH SUPERUSER $pass ;
		EOSQL
		echo

		{ echo; echo "host all all 0.0.0.0/0 $authMethod"; } >> "$PGDATA"/pg_hba.conf

		if [ -d /docker-entrypoint-initdb.d ]; then
			for f in /docker-entrypoint-initdb.d/*.sh; do
				[ -f "$f" ] && . "$f"
			done
		fi
	fi

	exec gosu postgres "$@"
fi

exec "$@"
