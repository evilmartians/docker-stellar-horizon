# Build stage
FROM golang:1.10.3-alpine3.8 AS builder

WORKDIR /go/src/github.com/stellar/go

RUN apk add --update --no-cache curl git mercurial

ARG GOOS=linux
ARG GOARCH=amd64
ARG CGO_ENABLED=0

ARG GLIDE_VERSION=0.13.1
ARG GLIDE_SHA256SUM=c403933503ea40308ecfadcff581ff0dc3190c57958808bb9eed016f13f6f32c

COPY scripts/install_glide.sh /tmp/

RUN /tmp/install_glide.sh

ARG HORIZON_VERSION=0.13.0

RUN git clone https://github.com/stellar/go.git . \
  && git checkout horizon-v${HORIZON_VERSION}
RUN glide --debug install
RUN go install -ldflags "-X github.com/stellar/go/support/app.version=$HORIZON_VERSION -X github.com/stellar/go/support/app.version=$(date +%FT%X%z)" github.com/stellar/go/services/horizon

# Release stage
FROM busybox:1.29.1

ARG VCS_REF
ARG BUILD_DATE

LABEL maintainer="Mobius Operations Team <ops@mobius.network>"
LABEL org.label-schema.build-date="${BUILD_DATE}"
LABEL org.label-schema.vcs-ref="${VCS_REF}"
LABEL org.label-schema.vcs-url="https://github.com/mobius-network/docker-stellar-horizon/"
LABEL org.label-schema.name="horizon"

COPY --from=builder /go/bin/horizon /usr/local/bin/horizon
COPY scripts/entrypoint.sh /entrypoint.sh

EXPOSE 8000

USER nobody

WORKDIR /tmp

ENTRYPOINT ["/entrypoint.sh", "/usr/local/bin/horizon"]
