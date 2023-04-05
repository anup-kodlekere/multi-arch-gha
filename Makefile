BASE_PATH = .

NPROCS ?= $(shell nproc)

.PHONY: builder
builder:
ifdef BUILD_BUILDER_IMAGE
	docker buildx build --push --platform ${ARCH} \
		--build-arg NPROCS=$(NPROCS) \
		-t localhost:5000/kodlekereanup/collector-builder:latest \
		-f "$(CURDIR)/Dockerfile.coll" \
		.
else
	docker pull quay.io/stackrox-io/collector-builder:$(COLLECTOR_BUILDER_TAG)
endif

collector: builder

image: collector 
	docker buildx build --push --platform ${ARCH} \
		-f "$(CURDIR)/Dockerfile" \
		-t localhost:5000/kodlekereanup/collector:latest .
