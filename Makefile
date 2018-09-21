# docker listener service makefile

APP_SERVICE_NAME = "auth0apache"
APP_SERVICE_OWNER = "taherbs"
CONTAINER_NAME = "$(APP_SERVICE_OWNER)/$(APP_SERVICE_NAME)"
PLATFORM="centos" #Alternative value "ubuntu"

# get the workdir depending on the OS
ifeq ($(OS),Windows_NT)
	WORK_DIR = $(CURDIR)
else
	WORK_DIR = $(PWD)
endif

.PHONY: build
build:
	docker build -f Dockerfile-$(PLATFORM) -t $(CONTAINER_NAME):latest .

.PHONY: start
start: stop build
	docker run --detach --publish 80:80 --publish 443:443 --name $(APP_SERVICE_NAME) --tty $(CONTAINER_NAME):latest

.PHONY: stop
stop:
	docker rm -f $(APP_SERVICE_NAME) || true

.PHONY: ssh
ssh:
	docker exec -it $(APP_SERVICE_NAME) bash

.PHONY: logs
logs:
	docker logs $(APP_SERVICE_NAME)
