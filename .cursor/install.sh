#!/usr/bin/env bash
# Idempotent Cloud Agent setup for the finsim repository.
# Installs the protobuf compiler and Go codegen plugins, then downloads
# module dependencies and compiles the Go module.
set -euo pipefail

# protoc (the protobuf compiler) is required by `make proto`. Its well-known
# type includes land in /usr/include, which the Makefile already targets.
if ! command -v protoc >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y --no-install-recommends protobuf-compiler
fi

# Go codegen plugins, pinned to the versions the committed stubs were built
# with. protoc-gen-go-grpc requires a newer Go toolchain than the base image,
# so let the Go toolchain manager fetch it on demand.
go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.36.6
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.6.1

# Module dependencies and a compile check for the Go API module.
cd "$(dirname "$0")/../api"
go mod download
go build ./...
