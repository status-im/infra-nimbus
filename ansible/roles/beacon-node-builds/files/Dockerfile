FROM alpine:3.12.1

ARG COMMIT

RUN apk add --no-cache libgcc pcre

COPY repo/build/* /usr/local/bin/

STOPSIGNAL SIGINT

ENTRYPOINT ["/usr/local/bin/beacon_node"]
