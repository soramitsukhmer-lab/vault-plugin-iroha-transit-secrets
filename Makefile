VERSION := 

it: clean build
clean:
	rm -rf ./binaries || true
build:
	VERSION=$(VERSION) docker buildx bake binaries
