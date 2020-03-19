FROM debian:stretch-slim AS base

ARG TARGETARCH

# The i386 is necessary due to pfclient only haveing an i386 client
# setting the dpkg architecture to i386 and adding libgcc1:i386 allows it to run
RUN \
    set -ex; \
    if [ ${TARGETARCH} != "amd64" ]; then \
    apt-get update && apt-get install -y --no-install-recommends \
    iputils-ping \
    libc-bin \
    libc-dbg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* ; \
    else \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    libgcc1:i386 \
    iputils-ping \
    libc-bin \
    libc-dbg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* ; \
    fi;



FROM --platform=$TARGETPLATFORM debian:stretch-slim AS builder

ARG TARGETARCH

ARG PFCLIENT_VERSION=4.1.1
ARG PFCLIENT_ARM_HASH=c2411ca2c9ce1a6a00c1c8af0ce3f7f9
ARG PFCLIENT_AMD_HASH=db3ffb12318ac6f75c4baf73d3f5644d

# Find the lastest version @ https://planefinder.net/sharing/client
# With the changelog @ https://planefinder.net/sharing/client_changelog
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    ca-certificates

RUN set -ex; \
    \
    if [ ${TARGETARCH} != "amd64" ]; then \
      curl --output pfclient.tar.gz "http://client.planefinder.net/pfclient_${PFCLIENT_VERSION}_armhf.tar.gz"; \
      md5sum pfclient.tar.gz && echo "${PFCLIENT_ARM_HASH}  pfclient.tar.gz" | md5sum -c ; \
    else \
      curl --output pfclient.tar.gz "http://client.planefinder.net/pfclient_${PFCLIENT_VERSION}_i386.tar.gz"; \
      md5sum pfclient.tar.gz && echo "${PFCLIENT_AMD_HASH}  pfclient.tar.gz" | md5sum -c ; \
    fi; \
    tar -xvf pfclient.tar.gz ; \
    mv pfclient /usr/local/bin/pfclient ; \
    rm pfclient.tar.gz

FROM base

COPY rootfs /

COPY --from=builder /usr/local/bin/pfclient /usr/local/bin/pfclient

EXPOSE 30053

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
