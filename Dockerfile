FROM debian:stretch-slim

ARG STELLAR_HORIZON_VERSION="0.13.0"
ARG STELLAR_HORIZON_RELEASE_SHA256SUM="becd53ed91e39d1d106065fbbed6765c135765afc97f692529ff4525d0b299e1"
ARG STELLAR_HORIZON_BUILD_DEPS="wget"

LABEL maintainer="admin@evilmartians.com"
LABEL thnx_to_satoshipay="true"

# install stellar horizon
ADD install.sh /
RUN /install.sh

# HTTP port
EXPOSE 8000

ADD entry.sh /
ENTRYPOINT ["/entry.sh"]

CMD ["horizon"]
