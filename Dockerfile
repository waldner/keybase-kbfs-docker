FROM golang:1.23.2-bookworm AS builder0-arm64
ENV DEBIAN_FRONTEND=noninteractive
RUN curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg -o /etc/apt/keyrings/yarn.asc && \
    echo "deb [signed-by=/etc/apt/keyrings/yarn.asc] https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn rsync fakeroot && \
    git clone https://github.com/keybase/client /tmp/client && \
    cd /tmp/client/packaging/linux && \
    export KEYBASE_BUILD_ARM_ONLY=1 && \
    ./build_binaries.sh prerelease /tmp/out && \
    sed -i 's|^export debian_arch=amd64|export debian_arch=arm64|' deb/package_binaries.sh && \
    deb/package_binaries.sh /tmp/out && \
    cp /tmp/out/deb/arm64/keybase-*-arm64.deb /tmp/keybase.deb

FROM debian:12-slim AS builder-arm64
COPY --from=builder0-arm64 /tmp/keybase.deb /tmp/keybase.deb

FROM debian:12-slim AS builder-amd64
RUN apt-get update && apt-get install -y curl && \
    cd /tmp && curl -s -o /tmp/keybase.deb https://prerelease.keybase.io/keybase_amd64.deb

# stupid trick
FROM builder-${TARGETARCH} AS final-builder

FROM debian:12-slim AS final
ENV DEBIAN_FRONTEND=noninteractive
COPY --from=final-builder /tmp/keybase.deb /tmp/keybase.deb
RUN apt-get update && apt-get install -y \
      perl-modules apt-utils gosu curl \
    && apt-get install -y /tmp/keybase.deb && \
    rm /tmp/keybase.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/*

RUN useradd -m keybase

COPY entrypoint.sh /tmp
COPY run_keybase.sh /tmp
RUN chmod +x /tmp/run_keybase.sh /tmp/entrypoint.sh

ENTRYPOINT ["/tmp/entrypoint.sh"]
CMD ["/tmp/run_keybase.sh"]

