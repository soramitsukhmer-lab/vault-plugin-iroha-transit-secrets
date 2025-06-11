# Enable cross-compilation for multiple architectures
FROM --platform=$BUILDPLATFORM golang:1.23.9-alpine AS stage1
WORKDIR /src

ARG VERSION=0.0.0
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=bind,source=.,target=/src,rw \
<<EOF
    set -euo pipefail
    go mod download
    go mod verify
    export CGO_ENABLED=0
    GOLDFLAGS="-s -w"
    mkdir -p /out
    for GOOS in darwin linux; do
        export GOOS=${GOOS}
            for GOARCH in amd64 arm64; do
                export GOARCH=${GOARCH}
                    go build -ldflags="${GOLDFLAGS}" -o /out/iroha-transit-${VERSION}-${GOOS}-${GOARCH} cmd/vault-plugin-iroha-transit-secrets/main.go
                unset GOARCH
            done
        unset GOOS
    done
    cd /out && {
        sha256sum iroha-transit-* > SHA256SUMS.txt
    }
EOF

FROM scratch AS binaries
COPY --from=stage1 /out/ /
