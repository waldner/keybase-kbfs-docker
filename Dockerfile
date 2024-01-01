FROM debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
      perl-modules \
      apt-utils \
      gosu \
      curl && \
    curl -s -O https://prerelease.keybase.io/keybase_amd64.deb && \
    apt-get install -y ./keybase_amd64.deb && \
    rm keybase_amd64.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/*

RUN useradd -m keybase

COPY entrypoint.sh /tmp
COPY run_keybase.sh /tmp
RUN chmod +x /tmp/run_keybase.sh /tmp/entrypoint.sh;

ENTRYPOINT ["/tmp/entrypoint.sh"]
CMD ["/tmp/run_keybase.sh"]

