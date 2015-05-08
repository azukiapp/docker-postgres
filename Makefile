# `adocker` is alias to `azk docker`
all:
	adocker build -t azukiapp/postgres 9.4
	adocker build -t azukiapp/postgres:9.4 9.4
	adocker build -t azukiapp/postgres:9.3 9.3

no-cache:
	adocker build --rm --no-cache -t azukiapp/postgres 9.4
	adocker build --rm --no-cache -t azukiapp/postgres:9.4 9.4
	adocker build --rm --no-cache -t azukiapp/postgres:9.3 9.3

test: all
	# Clear env before run tests
	azk stop pg94,pg93 || exit 0
	azk shell pg94 -c "rm -Rf /var/lib/postgresql/data/*"
	azk shell pg93 -c "rm -Rf /var/lib/postgresql/data/*"

	# Start and run a tests
	azk start pg94,pg93
	azk shell pg94-test -c "./node_modules/.bin/mocha"
	azk shell pg93-test -c "./node_modules/.bin/mocha"

	# Restart and run a tests
	azk restart pg94,pg93
	azk shell pg94-test -c "./node_modules/.bin/mocha"
	azk shell pg93-test -c "./node_modules/.bin/mocha"

	# Final clean
	azk stop pg94,pg93 || exit 0

.PHONY: test no-cache all
