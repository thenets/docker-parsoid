NAME = thenets/parsoid
TAG = latest
SHELL = /bin/bash

build: pre-build docker-build post-build

pre-build:

post-build:

docker-build:
	docker build -t $(NAME):$(TAG) --rm .

shell:
	docker run -it --rm --entrypoint=$(SHELL) -p 8080:80 $(NAME):$(TAG)

build-shell: build shell

build-test: build test

test:
	docker run -it --rm -p 8080:80 -e PARSOID_DOMAIN_localhost=http://localhost/w/api.php $(NAME):$(TAG)

unit-test:
	docker run -it --rm -w "/var/lib/parsoid" $(NAME):$(TAG) npm test