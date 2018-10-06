FROM debian:9-slim

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      perl-modules-5.24 \
      apt-utils \
      gosu \
      curl; \
    curl -s -O https://prerelease.keybase.io/keybase_amd64.deb && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y ./keybase_amd64.deb && \
    rm keybase_amd64.deb; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /var/cache/*

RUN useradd -m keybase

COPY entrypoint.sh /tmp
COPY run_keybase.sh /tmp
RUN chmod +x /tmp/run_keybase.sh /tmp/entrypoint.sh;

ENTRYPOINT ["/tmp/entrypoint.sh"]
CMD ["/tmp/run_keybase.sh"]

