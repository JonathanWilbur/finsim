#!/usr/bin/env bash
# Idempotent Cloud Agent setup for the finsim repository.
# Installs the protobuf compiler and Go codegen plugins, then downloads
# module dependencies and compiles the Go module.
set -euo pipefail

# `make proto` needs the protobuf compiler (protobuf-compiler) and the
# well-known-type .proto includes such as google/protobuf/timestamp.proto.
# On Ubuntu those includes ship in libprotobuf-dev (installed to /usr/include,
# which the Makefile already targets), NOT in protobuf-compiler, so both
# packages are named explicitly. Guard on the include the Makefile imports.
if [ ! -f /usr/include/google/protobuf/timestamp.proto ]; then
  sudo apt-get update
  sudo apt-get install -y --no-install-recommends protobuf-compiler libprotobuf-dev
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
