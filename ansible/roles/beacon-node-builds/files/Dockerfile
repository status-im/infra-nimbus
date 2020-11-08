FROM debian:bullseye-slim

ARG COMMIT

RUN apt-get -qq update \
 && apt-get -qq -y install libpcre3-dev &>/dev/null \
 && apt-get -qq clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY repo/build/beacon_node repo/build/signing_process /usr/local/bin/

STOPSIGNAL SIGINT

ENTRYPOINT ["/usr/local/bin/beacon_node"]

CMD ["--help"]
