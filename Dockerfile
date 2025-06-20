ARG VERSION=

# Enable cross-compilation for multiple architectures
FROM --platform=$BUILDPLATFORM golang:1.23.9-alpine AS stage1
WORKDIR /src

ARG VERSION
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=bind,source=.,target=/src,rw \
<<EOF
    set -xeuo pipefail
    go mod download
    go mod verify
    export CGO_ENABLED=0
    GOLDFLAGS="-s -w"
    mkdir -p /out
    for GOOS in darwin linux; do
        for GOARCH in amd64 arm64; do
            export GOOS GOARCH
            go build -ldflags="${GOLDFLAGS}" -o /out/iroha-transit${VERSION:+-${VERSION}}-${GOOS}-${GOARCH} cmd/vault-plugin-iroha-transit-secrets/main.go
        done
    done
EOF

FROM scratch AS binaries
COPY --from=stage1 /out/ /

FROM scratch
ARG TARGETARCH
ARG VERSION
COPY --from=binaries /iroha-transit${VERSION:+-${VERSION}}-linux-${TARGETARCH} /iroha-transit
ENTRYPOINT [ "/iroha-transit" ]
