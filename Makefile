IMAGE_NAME := "azukiapp/postgres"

# bins
DOCKER := $(shell which adocker || which docker)

all: build test

build:
	${DOCKER} build -t ${IMAGE_NAME}:latest   9.5
	${DOCKER} build -t ${IMAGE_NAME}:9.4      9.4
	${DOCKER} build -t ${IMAGE_NAME}:9.3      9.3

build-no-cache:
	${DOCKER} build --rm --no-cache -t ${IMAGE_NAME}:latest   9.5
	${DOCKER} build --rm --no-cache -t ${IMAGE_NAME}:9.4      9.4
	${DOCKER} build --rm --no-cache -t ${IMAGE_NAME}:9.3      9.3

test:
	# run bats of test to each version
	./test.sh latest # 9.5
	./test.sh 9.4
	./test.sh 9.3

.PHONY: test build build-no-cache all
