.PHONY: build network start stop clean

DOCKER=docker
IMAGE=dmgnx/nginx-naxsi
NAME=wrms-dash-nginx
STATIC_VOL=wrms-dash-frontend-vol
NETWORK=wrms-dash-net

build:
	:

network:
	$(DOCKER) network list | grep -q $(NETWORK) || $(DOCKER) network create $(NETWORK)

start:
	$(DOCKER) run \
        --name $(NAME) \
        --detach  \
        --publish 80:80 \
        --network $(NETWORK) \
        --volume /etc/localtime:/etc/localtime:ro \
        --volume $$PWD/nginx-default.conf:/etc/nginx/conf.d/default.conf:ro \
        --volume $(STATIC_VOL):/usr/share/nginx/html/static:ro \
        --rm \
        $(IMAGE)
	$(DOCKER) logs -f $(NAME)

stop:
	$(DOCKER) stop $(NAME)

clean:
	$(DOCKER) rmi $(IMAGE) $$($(DOCKER) images --filter dangling=true -q)

