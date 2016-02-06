/**
 * Documentation: http://docs.azk.io/Azkfile.js
 */

var version    = env.PGTEST_VERSION;
// Adds the systems that shape your system
systems({
  pg: {
    // More images:  http://images.azk.io
    image: { docker: "azukiapp/postgres:" + version },
    shell: "/bin/bash",
    wait: { "retry": 25, "timeout": 1000 },
    mounts: {
      '/var/lib/postgresql': persistent("#{manifest.dir}-data-" + version),
    },
    ports: {
      // exports global variables
      data: "5432/tcp",
    },
    envs: {
      // set instances variables
      POSTGRES_USER: "azk",
      POSTGRES_PASS: "azk",
      POSTGRES_DB  : "#{system.name}",
    },
    export_envs: {
      DATABASE_URL: "postgres://#{envs.POSTGRES_USER}:#{envs.POSTGRES_PASS}@#{net.host}:#{net.port.data}/${envs.POSTGRES_DB}",
    },
  },

  "pg-test": {
    // Dependent systems
    depends: [ "pg" ],
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
});
