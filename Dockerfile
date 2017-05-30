
FROM alpine

MAINTAINER Markus Juenemann <markus@juenemann.net>

RUN apk upgrade --update && \
    apk add --no-cache --virtual /tmp/.build-deps \
        openssl \
        openssl-dev \
        git \
        gcc \
        make \
        linux-headers \
        musl-dev \
        build-base \
        abuild \
        binutils \
        pax-utils \
        bash && \
    /bin/ls -l  /lib/libcrypto* /usr/lib/libcrypto* || echo xyz && \
    git clone https://github.com/peervpn/peervpn.git /tmp/peervpn.git && \
    cd /tmp/peervpn.git && \
    CFLAGS="-Wall" make && \
    cp peervpn /sbin/peervpn && \
    scanelf -n /sbin/peervpn && \
    chmod 755 /sbin/peervpn &&  \
    cd / && \
    rm -rf /tmp/peervpn.git && \
    apk del /tmp/.build-deps && \
    mkdir -p /dev/net && \
    mknod /dev/net/tun c 10 200

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
