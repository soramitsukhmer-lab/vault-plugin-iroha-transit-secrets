VERSION := 0.0.0-alpha.0

it:
clean:
	rm -rf ./bin || true
build:
	VERSION=$(VERSION) docker buildx bake binaries
