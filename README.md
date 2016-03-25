[azukiapp/postgres](http://images.azk.io/#/postgres?from=github-readme)
==================

Base docker image to run a PostgreSQL database server in [`azk`](http://azk.io)

[![Circle CI](https://circleci.com/gh/azukiapp/docker-postgres.svg?style=svg)](https://circleci.com/gh/azukiapp/docker-postgres)
[![ImageLayers Size](https://img.shields.io/imagelayers/image-size/azukiapp/postgres/latest.svg?style=plastic)](https://imagelayers.io/?images=azukiapp/postgres:latest)
[![ImageLayers Layers](https://img.shields.io/imagelayers/layers/azukiapp/postgres/latest.svg?style=plastic)](https://imagelayers.io/?images=azukiapp/postgres:latest)

Postgres versions (tags)
---

<versions>
- [`latest`, `9`, `9.5`, `9.5.0`](https://github.com/azukiapp/docker-postgres/blob/master/9.5/Dockerfile)
- [`9.4`, `9.4.5`](https://github.com/azukiapp/docker-postgres/blob/master/9.4/Dockerfile)
- [`9.3`, `9.3.10`](https://github.com/azukiapp/docker-postgres/blob/master/9.3/Dockerfile)
</versions>

Image content use https://github.com/docker-library/postgres

### Usage with `azk`

Example of using this image with [azk](http://azk.io):

```js
/**
 * Documentation: http://docs.azk.io/Azkfile.js
 */

// Adds the systems that shape your system
systems({
  postgres: {
    // More info about postgres image: http://images.azk.io/#/postgres?from=images-azkfile-postgres
    image: {"docker": "azukiapp/postgres:9.4"},
    shell: "/bin/bash",
    wait: {"retry": 25, "timeout": 1000},
    mounts: {
      '/var/lib/postgresql/data': persistent("#{system.name}-data"),
    },
    ports: {
      // exports global variables: "#{net.port.data}"
      data: "5432/tcp",
    },
    envs: {
      // set instances variables
      POSTGRES_USER: "azk",
      POSTGRES_PASS: "azk",
      POSTGRES_DB  : "#{manifest.dir}",
    },
    export_envs: {
      // check this gist to configure your database
      // Ruby eg in: https://gist.github.com/gullitmiranda/62082f2e47c364ef9617
      DATABASE_URL: "postgres://#{envs.POSTGRES_USER}:#{envs.POSTGRES_PASS}@#{net.host}:#{net.port.data}/#{envs.POSTGRES_DB}",
      // Exlir eg in: https://github.com/azukiapp/hello_phoenix/blob/master/config/database.uri.exs
      // DATABASE_URL: "ecto+postgres://#{envs.POSTGRES_USER}:#{envs.POSTGRES_PASS}@#{net.host}:#{net.port.data}/#{envs.POSTGRES_DB}",
      // or use splited envs:
      // POSTGRES_USER: "#{envs.POSTGRES_USER}",
      // POSTGRES_PASS: "#{envs.POSTGRES_PASS}",
      // POSTGRES_HOST: "#{net.host}",
      // POSTGRES_PORT: "#{net.port.data}",
      // POSTGRES_DB  : "#{envs.POSTGRES_DB}",
    },
  },
});
```

###### NOTE:

Do not forget to add `postgres` as a dependency of your application:

e.g.:

```js
systems({
  'my-app': {
    // Dependent systems
    depends: ["postgres"],
    /* ... */
  },
  'postgres': { /* ... */ }
})
```

### Usage with `docker`

To create the image `azukiapp/postgres`, execute the following command on the docker-postgres folder:

```sh
$ docker build -t azukiapp/postgres:9.4 ./9.4
```

To run the image and bind to port 5432:

```sh
$ docker run -d -p 5432:5432 azukiapp/postgres
```

### Tests

Obs: Very slow process

```
$ make test
```

### Logs

```sh
# with azk
$ azk logs postgres

# with docker
$ docker logs <CONTAINER_ID>
```

### Environment variables

`POSTGRES_USER`: Set a specific username for the admin account. (default 'azk')

`POSTGRES_PASS`: Set a specific password for the admin account. (default 'azk')

`POSTGRES_DB`: Set a specific database name

Clean DB data
-------------

to clean postgres data, run:

```shell
# this makes sure that postgres is stopped
$ azk stop postgres
# remove all files in $PGDATA (`/*` is required)
$ azk shell postgres -- rm -rf "\$PGDATA/*"
```

Migrating an existing PostgreSQL Server
----------------------------------

In order to migrate your current PostgreSQL server, perform the following commands from your current server:

### Export dump

```sh
$ pg_dump --host <host> --port <port> --username <name> --password=<password> --dbname <database name> > dbexport.sql
```

### Import from dump (Manual)

```sh
$ azk start postgres
azk: ↑ starting `postgres` system, 1 new instances...
azk: ✓ checking `azukiapp/postgres:9.4` image...
azk: ◴ waiting for `postgres` system to start, trying connection to port data/tcp...

┌───┬──────────┬───────────┬──────────────┬─────────────────┬──────────────┐
│   │ System   │ Instances │ Hostname/url │ Instances-Ports │ Provisioned  │
├───┼──────────┼───────────┼──────────────┼─────────────────┼──────────────┤
│ ↑ │ postgres │ 1         │ dev.azk.io   │ 1-data:32768    │ 2 months ago │
└───┴──────────┴───────────┴──────────────┴─────────────────┴──────────────┘

$ azk shell postgres
$ psql --host dev.azk.io --port 32768 --username ${POSTGRES_USER} --password=${POSTGRES_PASS} --dbname=${POSTGRES_DB} < dbexport.sql
```

NOTE: remember to replace the `port` number through which it is running (as in the table above or using the `azk status`)

### Auto import using Azkfile

you can use the [entrypoint](https://github.com/docker-library/postgres/blob/3f8e9784438c8fe54f831c301a45f4d55f6fa453/9.5/docker-entrypoint.sh) of the image of postgres to do the loading of the dump automatically.

1. put all dump files in `./data-dump/`
2. Add the mount:

```js
    mounts: {
      '/var/lib/postgresql/data'    : persistent("#{system.name}-data"),
      '/docker-entrypoint-initdb.d/': path("./data-dump/"),
    },
```

- valid extendions: `.sh`, `.sql` and `.sql.gz`;

> NOTE: the charging process is automated, as well as the creation of the database is done only the first time.
> To clean DB data see section [Clean DB data](#clean-db-data)


## License

Azuki Dockerfiles distributed under the [Apache License][license].

[license]: ./LICENSE
