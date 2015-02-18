FROM azukiapp/ubuntu
MAINTAINER Azuki <support@azukiapp.com>

ENV POSTGRES_VERSION 9.4
ENV DEBIAN_FRONTEND noninteractive

# Add the PostgreSQL PGP key to verify their Debian packages.
# It should be the same key as https://www.postgresql.org/media/keys/ACCC4CF8.asc
RUN  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8 \
  && echo "deb http://apt.postgresql.org/pub/repos/apt/ wheezy-pgdg main $POSTGRES_VERSION" > /etc/apt/sources.list.d/pgdg.list

# Install packages
RUN  apt-get update \
  && apt-get -yq install locales sudo \
  && apt-get -yq install --no-install-recommends \
      libpq5 \
      postgresql-$POSTGRES_VERSION \
      postgresql-client-$POSTGRES_VERSION \
      postgresql-contrib-$POSTGRES_VERSION \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/cache/apt

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/$POSTGRES_VERSION/main/pg_hba.conf && \
    echo "listen_addresses='*'" >> /etc/postgresql/$POSTGRES_VERSION/main/postgresql.conf

COPY docker-entrypoint.sh /docker-entrypoint
COPY run /usr/local/bin/run

# Note: This container has no native volume, its expected to run with --volumes-from another

EXPOSE 5432

ENTRYPOINT ["/docker-entrypoint"]
CMD ["/usr/local/bin/run"]
