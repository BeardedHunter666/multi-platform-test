APP_NAME=product-app
IMAGE_TAG=quay.io/yourname/product-test:latest

HOST_PLATFORM=$(shell uname -s | tr '[:upper:]' '[:lower:]')
HOST_ARCH=$(shell uname -m)


ifeq ($(HOST_ARCH),x86_64)
    HOST_ARCH=amd64
endif
ifeq ($(HOST_ARCH),aarch64)
    HOST_ARCH=arm64
endif

linux:
	GOOS=linux GOARCH=amd64 go build -o bin/$(APP_NAME)-linux-amd64 main.go

arm:
	GOOS=linux GOARCH=arm64 go build -o bin/$(APP_NAME)-linux-arm64 main.go

macos:
	GOOS=darwin GOARCH=amd64 go build -o bin/$(APP_NAME)-darwin-amd64 main.go

windows:
	GOOS=windows GOARCH=amd64 go build -o bin/$(APP_NAME)-windows-amd64.exe main.go

image:
	docker build \
		--platform=$(HOST_PLATFORM)/$(HOST_ARCH) \
		-t $(IMAGE_TAG) \
		--build-arg TARGETOS=$(HOST_PLATFORM) \
		--build-arg TARGETARCH=$(HOST_ARCH) \
		.

clean:
	docker rmi $(IMAGE_TAG) || true
	rm -rf bin
