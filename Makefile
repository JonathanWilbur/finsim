# Regenerate Go types from finsim.proto (requires protoc, protoc-gen-go, protoc-gen-go-grpc).
# Override if google/protobuf includes live elsewhere (e.g. Homebrew: PROTOBUF_INCLUDE=/opt/homebrew/opt/protobuf/include).
PROTOBUF_INCLUDE ?= /usr/include

GOPATH_BIN := $(shell go env GOPATH)/bin
export PATH := $(GOPATH_BIN):$(PATH)

.PHONY: proto proto-tools

proto: proto-tools
	protoc -I. -I$(PROTOBUF_INCLUDE) \
		--go_out=api/finsimpb --go_opt=paths=source_relative \
		--go-grpc_out=api/finsimpb --go-grpc_opt=paths=source_relative \
		finsim.proto

proto-tools:
	@command -v protoc >/dev/null 2>&1 || { echo "Install protoc (https://grpc.io/docs/protoc-installation/)."; exit 1; }
	@command -v protoc-gen-go >/dev/null 2>&1 || { echo "Install: go install google.golang.org/protobuf/cmd/protoc-gen-go@latest"; exit 1; }
	@command -v protoc-gen-go-grpc >/dev/null 2>&1 || { echo "Install: go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest"; exit 1; }
