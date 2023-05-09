BASE_PATH = .

NPROCS ?= $(shell nproc)
ARCH ?= amd64

.PHONY: builder
builder:
ifdef BUILD_BUILDER_IMAGE
	docker buildx build --push --platform ${ARCH} \
		--build-arg NPROCS=$(NPROCS) \
		-t anupkodlekere/multiarchbuild:latest \
		-f "$(CURDIR)/Dockerfile.coll" \
		.
else
	docker pull quay.io/stackrox-io/collector-builder:$(COLLECTOR_BUILDER_TAG)
endif

collector: builder

image: collector 
	docker buildx build --push --platform ${ARCH} \
		-f "$(CURDIR)/Dockerfile" \
		-t anupkodlekere/multiarch-test:latest .
