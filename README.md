[![Travis master branch](https://img.shields.io/travis/mjuenema/docker-alpine-peervpn/master.svg?style=flat-square)](https://travis-ci.org/mjuenema/docker-alpine-peervpn/branches)
[![Travis develop branch](https://img.shields.io/travis/mjuenema/docker-alpine-peervpn/develop.svg?style=flat-square)](https://travis-ci.org/mjuenema/docker-alpine-peervpn/branches)
[![GitHub release](https://img.shields.io/github/release/mjuenema/docker-alpine-peervpn.svg?style=flat-square)](https://github.com/mjuenema/docker-alpine-peervpn)

# Docker image running PeerVPN

## Usage

Pull the image from Dockerhub.

    docker pull mjuenema/alpine-peervpn

### Running the image directly

The default `ENTRYPOINT` will generate a configuration file for PeerVPN
(unless one exists already) based on supplied environment variables and 
then run the `peervpn` binary.

The following environment variables are supported. Note that some default
values are of limited use.

| Variable | Default |
|----------|---------|
| NETWORKNAME | PEERVPN$RANDOM |
| PSK | PSK$RANDOM |
| INITPEERS | example.com 7000 |
| ENABLETUNNELING | yes |
| INTERFACE | peervpn0 |
| IFCONFIG4 | 172.16.254.$(expr $RANDOM % 256)/24 |
| IFCONFIG4 | fe80::1034:56ff:fe78:$(expr $RANDOM % 10000)/64 |
| LOCAL | 0.0.0.0 |
| PORT | 7000 |
| ENABLEIPV4 | yes |
| ENABLEIPV6 | yes |
| ENABLERELAY | no |

The example below will run a VPN between two containers. Both containers must
configure different UDP ports (7001 and 7002) as they are on the same host. 
In the example below the IP address of the host running Docker is 10.0.2.15.

    docker run --name=vpn1 -p 7001:7001/udp --privileged \
        -e NETWORKNAME=mynet -e PSK=mykey -e PORT=7001 \
        -e INITPEERS='10.0.2.15 7002' -e IFCONFIG4='172.16.1.1/24' -d \
        mjuenema/alpine-peervpn
    
    docker run --name=vpn2 -p 7002:7002/udp --privileged \
        -e NETWORKNAME=mynet -e PSK=mykey -e PORT=7002 \
        -e INITPEERS='10.0.2.15 7001' -e IFCONFIG4='172.16.1.2/24' -d \
        mjuenema/alpine-peervpn

### Use as a base image

This image can also be used as a base image. `COPY` your own PeerVPN configuration
file and overwrite the `ENTRYPOINT`.

```
FROM mjuenema/alpine-linux

COPY peervpn.conf /etc/peervpn.conf

ENTRYPOINT ['/sbin/peervpn', '/etc/peervpn.conf']
```

## Author

Markus Juenemann <markus@juenemann.net>

## Changelog

### `0.2`

* Fixed [Issue 4](https://github.com/mjuenema/docker-alpine-peervpn/issues/4). Thanks
  to *jazzdd86* for reporting it.
* Added testing with Travis-CI against multiple Alpine Linux releases.

### `0.1`

* Initial version.
