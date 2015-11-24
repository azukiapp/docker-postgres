DOCKER := $(shell which adocker || which docker)
IMAGE_NAME := "azukiapp/postgres"

all:
	${DOCKER} build -t ${IMAGE_NAME} 9.4
	${DOCKER} build -t ${IMAGE_NAME}:9.4 9.4
	${DOCKER} build -t ${IMAGE_NAME}:9.3 9.3

no-cache:
	${DOCKER} build --rm --no-cache -t ${IMAGE_NAME} 9.4
	${DOCKER} build --rm --no-cache -t ${IMAGE_NAME}:9.4 9.4
	${DOCKER} build --rm --no-cache -t ${IMAGE_NAME}:9.3 9.3

test: all
	# Clear env before run tests
	azk stop pg94,pg93 || exit 0
	azk shell pg94 -c "rm -Rf /var/lib/postgresql/data/*"
	azk shell pg93 -c "rm -Rf /var/lib/postgresql/data/*"

	# Run provision of test systems
	azk shell pg93-test -c "npm install"
	azk shell pg93-test -c "npm install"

	# Start and run a tests
	azk start pg94,pg93
	azk shell pg93-test -c "./node_modules/.bin/mocha"
	azk shell pg93-test -c "./node_modules/.bin/mocha"

	# Restart and run a tests
	azk restart pg94,pg93
	azk shell pg94-test -c "./node_modules/.bin/mocha"
	azk shell pg93-test -c "./node_modules/.bin/mocha"

	# Final clean
	azk stop pg94,pg93 || exit 0

.PHONY: test no-cache all
