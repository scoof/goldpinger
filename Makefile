name ?= goldpinger
version ?= v3.2.0
bin ?= goldpinger
pkg ?= "github.com/bloomberg/goldpinger"
tag = $(name):$(version)
goos ?= ${GOOS}
namespace ?= "scoof/"
files = $(shell find . -iname "*.go")


binaries: bin/$(bin)-amd64 bin/$(bin)-arm64

bin/$(bin)-arm64: $(files)
	GOOS=${goos} PKG=${pkg} ARCH=arm64 VERSION=${version} BIN=${bin} ./build/build.sh

bin/$(bin)-amd64: $(files)
	GOOS=${goos} PKG=${pkg} ARCH=amd64 VERSION=${version} BIN=${bin} ./build/build.sh

clean:
	rm -rf ./vendor
	rm -f ./bin/$(bin)

vendor:
	rm -rf ./vendor
	go mod vendor

# Download the latest swagger releases from: https://github.com/go-swagger/go-swagger/releases/
swagger:
	swagger generate server -t pkg -f ./swagger.yml --exclude-main -A goldpinger && \
	swagger generate client -t pkg -f ./swagger.yml -A goldpinger

build-multistage:
	docker buildx build --platform linux/amd64,linux/arm64 -t $(tag) -f ./Dockerfile .
	docker buildx build -t $(tag) -f ./Dockerfile --load .

build: GOOS=linux
build: binaries
	docker buildx build --platform linux/amd64,linux/arm64 -t $(tag) -f ./build/Dockerfile-simple .
	# TODO: any other way to get image in local registry?
	docker buildx build -t $(tag) -f ./build/Dockerfile-simple --load .

tag:
	docker tag $(tag) $(namespace)$(tag)

push:
	docker push $(namespace)$(tag)

run:
	go run ./cmd/goldpinger/main.go

version:
	@echo $(tag)


vendor-build:
	docker buildx build --platform linux/amd64,linux/arm64 -t $(tag)-vendor --build-arg TAG=$(tag) -f ./build/Dockerfile-vendor .
	# TODO: any other way to get image in local registry?
	docker buildx build -t $(tag)-vendor --build-arg TAG=$(tag) -f ./build/Dockerfile-vendor --load .

vendor-tag:
	docker tag $(tag)-vendor $(namespace)$(tag)-vendor

vendor-push:
	docker push $(namespace)$(tag)-vendor


.PHONY: clean vendor swagger build build-multistage vendor-build vendor-tag vendor-push tag push run version
