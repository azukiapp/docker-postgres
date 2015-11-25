[azukiapp/postgres](http://images.azk.io/#/postgres?from=github-readme)
==================
[![Circle CI](https://circleci.com/gh/azukiapp/docker-postgres.svg?style=svg)](https://circleci.com/gh/azukiapp/docker-postgres)

Base docker image to run a PostgreSQL database server in [`azk`](http://azk.io)

Postgres versions (tags)
---

<versions>
- [`latest`, `9`, `9.4`, `9.4.5`](https://github.com/azukiapp/docker-postgres/blob/master/9.4/Dockerfile)
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
      // to clean postgres data, run:
      // $ azk shell postgres -c "rm -rf /var/lib/postgresql/data/*"
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
      DATABASE_URL: "postgres://#{envs.POSTGRES_USER}:#{envs.POSTGRES_PASS}@#{net.host}:#{net.port.data}/${envs.POSTGRES_DB}",
      // Exlir eg in: https://github.com/azukiapp/hello_phoenix/blob/master/config/database.uri.exs
      // DATABASE_URL: "ecto+postgres://#{envs.POSTGRES_USER}:#{envs.POSTGRES_PASS}@#{net.host}:#{net.port.data}/${envs.POSTGRES_DB}",
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

## License

Azuki Dockerfiles distributed under the [Apache License][license].

[license]: ./LICENSE
