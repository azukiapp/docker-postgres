# `adocker` is alias to `azk docker`
all:
	adocker build -t azukiapp/postgres 9.3
	adocker build -t azukiapp/postgres:9.4 9.4

no-cache:
	adocker build --rm --no-cache -t azukiapp/postgres 9.3
	adocker build --rm --no-cache -t azukiapp/postgres:9.4 9.4
