[azukiapp/postgres](http://images.azk.io/#/postgres)
==================

Base docker image to run a PostgreSQL database server in [`azk`](http://azk.io)

Postgres versions (tags)
---

<versions>
- [`9.3`](https://github.com/azukiapp/docker-postgres/blob/master/9.3/Dockerfile)
- [`9.4`, `9`, `latest`](https://github.com/azukiapp/docker-postgres/blob/master/9.4/Dockerfile)
</versions>

Image content:
---

- debian:wheezy
- PostgreSQL

### Usage with `azk`

Example of using this image with [azk](http://azk.io):

```js
/**
 * Documentation: http://docs.azk.io/Azkfile.js
 */

// Adds the systems that shape your system
systems({
  postgres: {
    // Dependent systems
    depends: [], // postgres, postgres, mongodb ...
    // More images:  http://images.azk.io
    image: {"docker": "azukiapp/postgres"},
    shell: "/bin/bash",
    wait: {"retry": 25, "timeout": 1000},
    mounts: {
      '/var/lib/postgresql/data': persistent("postgresql-#{system.name}"),
      '/var/log/postgresql': path("./log/postgresql"),
    },
    ports: {
      // exports global variables
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
      // https://gist.github.com/gullitmiranda/62082f2e47c364ef9617
      DATABASE_URL: "postgres://#{envs.POSTGRES_USER}:#{envs.POSTGRES_PASS}@#{net.host}:#{net.port.data}/${envs.POSTGRES_DB}",
    },
  },
});
```

### Usage with `docker`

To create the image `azukiapp/postgres`, execute the following command on the docker-postgres folder:

```sh
$ docker build -t azukiapp/postgres ./9.4
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

`POSTGRES_USER` or `POSTGRESQL_USER`: Set a specific username for the admin account. (default 'azk')

`POSTGRES_PASS` or `POSTGRESQL_PASS`: Set a specific password for the admin account. (default 'azk')

`POSTGRES_DB` or `POSTGRESQL_DB`  : Set a specific database name

## License

Azuki Dockerfiles distributed under the [Apache License](https://github.com/azukiapp/dockerfiles/blob/master/LICENSE).
