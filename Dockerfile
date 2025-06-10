# Enable cross-compilation for multiple architectures
FROM --platform=$BUILDPLATFORM golang:1.23.9-alpine AS stage1
WORKDIR /src
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=bind,source=.,target=/src,rw \
<<EOF
    set -euo pipefail
    export CGO_ENABLED=0
    go mod download
    go mod verify
    for GOOS in darwin linux; do
        export GOOS=${GOOS}
            for GOARCH in amd64 arm64; do
                export GOARCH=${GOARCH}
                    go build -o /bin/iroha-transit-${GOOS}-${GOARCH} cmd/vault-plugin-iroha-transit-secrets/main.go
                unset GOARCH
            done
        unset GOOS
    done
EOF

FROM scratch AS binaries
COPY --from=stage1 /bin/iroha-transit-* /
