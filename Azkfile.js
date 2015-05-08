/**
 * Documentation: http://docs.azk.io/Azkfile.js
 */

// Adds the systems that shape your system
systems({
  pg94: {
    // More images:  http://images.azk.io
    image: { docker: 'azukiapp/postgres:9.4' },
    shell: "/bin/bash",
    wait: { "retry": 25, "timeout": 1000 },
    mounts: {
      '/var/lib/postgresql': persistent("postgresql-#{system.name}"),
    },
    ports: {
      // exports global variables
      data: "5432/tcp",
    },
    envs: {
      // set instances variables
      POSTGRESQL_USER: "azk",
      POSTGRESQL_PASS: "azk",
      POSTGRESQL_DB  : "#{system.name}",
    },
    export_envs: {
      DATABASE_URL: "postgres://#{envs.POSTGRESQL_USER}:#{envs.POSTGRESQL_PASS}@#{net.host}:#{net.port.data}/${envs.POSTGRESQL_DB}",
    },
  },

  "pg94-test": {
    // Dependent systems
    depends: [ "pg94" ],
    // More images:  http://images.azk.io
    image: { "docker": "azukiapp/node" },
    // Steps to execute before running instances
    provision: [
      "npm install",
    ],
    workdir: "/azk/#{manifest.dir}",
    shell: "/bin/bash",
    mounts: {
      '/azk/#{manifest.dir}': path("."),
      '/azk/#{manifest.dir}/node_modules': persistent("node_modules"),
    },
  },

  pg93: {
    extends: 'pg94',
    image: { docker: 'azukiapp/postgres:9.3' },
  },

  'pg93-test': {
    extends: 'pg94-test',
    depends: [ "pg93" ]
  },
});
