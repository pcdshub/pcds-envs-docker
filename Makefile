all: build run

build:
	docker build -t pcds-env -f Dockerfile $(PWD)

run:
	docker run -i -t pcds-env


.PHONY: build run all
