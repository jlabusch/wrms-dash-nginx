.PHONY: deps build network start stop clean

DOCKER=docker
IMAGE=jlabusch/wrms-dash-nginx
FRONTEND_IMAGE=jlabusch/wrms-dash-frontend
NAME=wrms-dash-nginx
NETWORK=wrms-dash-net
BUILD=$(shell ls ./wrms-dash-build-funcs/build.sh 2>/dev/null || ls ../wrms-dash-build-funcs/build.sh 2>/dev/null)
SHELL:=/bin/bash

deps:
	@test -n "$(BUILD)" || (echo 'wrms-dash-build-funcs not found; do you need "git submodule update --init"?'; false)
	@echo "Using $(BUILD)"
	@$(BUILD) image exists $(FRONTEND_IMAGE) || $(BUILD) error "Can't find docker image $(FRONTEND_IMAGE) - do you need to build wrms-dash-frontend?"

build: deps
	@mkdir -p ./static
	$(BUILD) cp $(FRONTEND_IMAGE) $$PWD/static /opt/staticserve /vol0/
	$(BUILD) build $(IMAGE)
	@rm -fr ./static

network:
	$(BUILD) network create $(NETWORK)

start: network
	$(DOCKER) run \
        --name $(NAME) \
        --detach  \
        --publish 80:80 \
        --network $(NETWORK) \
        --volume /etc/localtime:/etc/localtime:ro \
        --rm \
        $(IMAGE)
	$(DOCKER) logs -f $(NAME) &

stop:
	$(DOCKER) stop $(NAME)

clean:
	$(BUILD) image delete $(IMAGE) || :

