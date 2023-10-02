FROM alpine:latest

LABEL maintainer="Francois Lacroix <xbgmsharp@gmail.com> (@xbgmsharp)"

ENV PGBADGER_DATA=/data
ENV PGBADGER_VERSION=11.1
ENV PGBADGER_PREFIX=/opt/pgbadger-${PGBADGER_VERSION}
ENV PATH=${PGBADGER_PREFIX}:$PATH

RUN LOCATION=$(wget -q https://api.github.com/repos/darold/pgbadger/releases/latest -O - | grep tarball_url  | awk '{ print $2 }' | sed 's/,$//' | sed 's/"//g') ; wget -O latest.tgz ${LOCATION}

RUN apk update && apk upgrade && apk --no-cache add coreutils \
    openssl \
    perl \
  && mkdir -p /data /opt \
  && tar -zxvf latest.tgz -C /opt \
  && chmod +x /opt/darold-pgbadger-*/pgbadger

COPY docker-entrypoint.sh /entrypoint.sh

VOLUME $PGBADGER_DATA

ENTRYPOINT ["/entrypoint.sh"]

CMD ["pgbadger"]
