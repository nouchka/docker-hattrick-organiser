DOCKER_IMAGE=hattrick-organiser

include Makefile.docker

.PHONY: check-version
check-version:
	docker run --rm --entrypoint printenv $(DOCKER_NAMESPACE)/$(DOCKER_IMAGE):$(VERSION)| grep VERSION| awk -F '=' '{print $$2}'
