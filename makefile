include .env

CONTAINERS != docker container ls -q --filter ancestor=$(IMAGE)

all: build run

build:
	docker build . --rm -t $(IMAGE)

run:
	docker run --rm -d --init --env-file=./.env $(if $(PORT),-p $(PORT):$(PORT)) $(IMAGE)

stop:
	docker container stop $(CONTAINERS)

clean:
	-docker container rm $(shell docker container ls -aq --filter ancestor=$(TAG))
	-docker rmi $(IMAGE)
	-docker image prune

exec:
	docker exec -it $(word 1,$(CONTAINERS)) /bin/ash

logs:
	docker logs $(word 1,$(CONTAINERS)) -f

.PHONY: all build run stop clean exec logs
