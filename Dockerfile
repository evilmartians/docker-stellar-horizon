# Build stage
FROM golang:1.10.3-alpine3.8 AS builder

WORKDIR /go/src/github.com/stellar/go

RUN apk add --update --no-cache curl git mercurial

ARG GOOS=linux
ARG GOARCH=amd64
ARG CGO_ENABLED=0

ARG DEP_VERSION=0.5.0
ARG DEP_SHA256SUM=287b08291e14f1fae8ba44374b26a2b12eb941af3497ed0ca649253e21ba2f83

COPY scripts/install_dep.sh /tmp/

RUN /tmp/install_dep.sh

ARG HORIZON_VERSION=v0.14.2

RUN git clone https://github.com/stellar/go.git . \
  && git checkout horizon-${HORIZON_VERSION}
RUN dep ensure -v
RUN go install -ldflags "-X github.com/stellar/go/support/app.version=$HORIZON_VERSION" github.com/stellar/go/services/horizon

# Release stage
FROM busybox:1.29.2

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
