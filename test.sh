#! /bin/sh

{ # This ensures the entire script is downloaded

# - Show and exit on errors
set -e

main() {
  if [ -z $1 ]; then
    usage
    exit 1
  fi

  if command_exists azk; then
    run_test $1
  else
    azk_install_instructions
    exit 1
  fi
}

run_test() {
  VERSION=$1
  export PGTEST_VERSION=${VERSION}
  echo "Run tests to postgres v${VERSION}"
  echo
  azk shell pg -c "rm -Rf /var/lib/postgresql/data/*"
  azk start pg
  azk shell pg-test -c "npm install"
  azk shell pg-test -c "./node_modules/.bin/mocha"
  azk stop pg
}

# Helps

usage() {
  echo "empty version to test"
  echo "USAGE:"
  echo "  ${0} <version>"
  echo ""
  echo "EXAMPLE:"
  echo "  ${0} 9.5"
}

azk_install_instructions() {
  echo "tests needs azk to be installed."
  echo "  to install azk run the command bellow:"
  echo "  $ $(curl_or_wget) https://get.docker.com/ | sh"
}
# Misc helpers

curl_or_wget() {
  CURL_BIN="curl"; WGET_BIN="wget"
  if command_exists ${CURL_BIN}; then
    echo "${CURL_BIN} -sSL"
  elif command_exists ${WGET_BIN}; then
    echo "${WGET_BIN} -nv -O- -t 2 -T 10"
  fi
}

command_exists() {
  command -v "${@}" > /dev/null 2>&1
}

main "${@}"

} # This ensures the entire script is downloaded
