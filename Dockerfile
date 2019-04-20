ARG BASE=debian:stretch-slim

FROM $BASE

ARG arch=none
ENV ARCH=$arch

COPY qemu/qemu-$ARCH-static* /usr/bin/

ARG PFCLIENT_VERSION=4.1.1
ARG PFCLIENT_ARM_HASH=c2411ca2c9ce1a6a00c1c8af0ce3f7f9
ARG PFCLIENT_AMD_HASH=db3ffb12318ac6f75c4baf73d3f5644d

# Find the lastest version @ https://planefinder.net/sharing/client
# With the changelog @ https://planefinder.net/sharing/client_changelog
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    iputils-ping \
    libc-bin \
    libc-dbg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN set -ex; \
    \
    if [ ${ARCH} = "arm" -o ${ARCH} = "arm64" ]; then \
      curl --output pfclient.tar.gz "http://client.planefinder.net/pfclient_${PFCLIENT_VERSION}_armhf.tar.gz"; \
      md5sum pfclient.tar.gz && echo "${PFCLIENT_ARM_HASH}  pfclient.tar.gz" | md5sum -c ; \
    fi; \
    if [ ${ARCH} = "amd64" ]; then \
      curl --output pfclient.tar.gz "http://client.planefinder.net/pfclient_${PFCLIENT_VERSION}_i386.tar.gz"; \
      md5sum pfclient.tar.gz && echo "${PFCLIENT_AMD_HASH}  pfclient.tar.gz" | md5sum -c ; \
    fi; \
    tar -xvf pfclient.tar.gz ; \
    mv pfclient /usr/local/bin/pfclient ; \
    rm pfclient.tar.gz

COPY pfclient-runner.sh /usr/local/bin/pfclient-runner

COPY pfclient-config.json /etc/pfclient-config.json

EXPOSE 30053

HEALTHCHECK --start-period=1m --interval=30s --timeout=5s --retries=3 CMD curl --fail http://localhost:30053/ || exit 1

ENTRYPOINT ["pfclient-runner"]

# Metadata
ARG VCS_REF="Unknown"
LABEL maintainer="ginnserv@gmail.com" \
      org.label-schema.name="Docker ADS-B - planefinder" \
      org.label-schema.description="Docker container for ADS-B - This is the planefinder.net component" \
      org.label-schema.url="https://github.com/ShoGinn/planefinder" \
      org.label-schema.vcs-ref="${VCS_REF}" \
      org.label-schema.vcs-url="https://github.com/ShoGinn/planefinder" \
      org.label-schema.schema-version="1.0"
