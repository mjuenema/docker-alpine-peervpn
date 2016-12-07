
FROM alpine

MAINTAINER Markus Juenemann <markus@juenemann.net>

RUN apk add --no-cache --virtual /tmp/.build-deps \
        openssl \
        openssl-dev \
        git \
        gcc \
        make \
        linux-headers \
        libc-dev \
        build-base \
        abuild \
        binutils \
        bash && \
    git clone https://github.com/peervpn/peervpn.git /tmp/peervpn.git && \
    cd /tmp/peervpn.git && \
    bash -c make && \
    cp peervpn /sbin/peervpn && \
    chmod 755 /sbin/peervpn &&  \
    cd / && \
    rm -rf /tmp/peervpn.git && \
    apk del /tmp/.build-deps

COPY peervpn.conf.in /etc/peervpn.conf.in

EXPOSE 7000

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
