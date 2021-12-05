FROM golang:1.14-alpine as builder

# Install our build tools

RUN apk add --update git make bash

# Get dependencies

WORKDIR /w
COPY go.mod go.sum /w/
RUN go mod download

# Build goldpinger

COPY . ./
RUN make binaries

# Build the asset container, copy over goldpinger

FROM scratch

ARG TARGETARCH

COPY --from=builder /w/bin/goldpinger-${TARGETARCH} /goldpinger
COPY ./static /static
ENTRYPOINT ["/goldpinger", "--static-file-path", "/static"]
