.PHONY: all
all:
	docker build -t briandowns/rancher-build-base:v0.1.1 .

.PHONY: image-push
image-push:
	docker push briandowns/rancher-build-base:v0.1.1

.PHONY: image-manifest
image-manifest:
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest create briandowns/rancher-build-base:v0.1.1 \
		$(shell docker image inspect briandowns/briandowns/rancher-build-base:v0.1.1 | jq -r '.[] | .RepoDigests[0]')
