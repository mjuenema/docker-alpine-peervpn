# Docker image running PeerVPN

WARNING: This is currently under heavy development.

## Usage

Pull the image from Dockerhub:

    docker pull mjuenema/alpine-peervpn

### Running the image directly

The default `ENTRYPOINT` will generate a configuration file for PeerVPN
(unless one exists already) based on supplied environment variables and 
then run the `peervpn` binary.

   run --privileged -e NETWORKNAME=mynet -e PSK=mykey -e ... -d mjuenema/alpine-peervpn

The following environment variables are supported. Note that some default
values are of limited use.

| Variable | Default |
----------------------
| NETWORKNAME | PEERVPN$RANDOM}
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

### Use as a base image

This image can also be used as a base image. `COPY` your own PeerVPN configuration
file and overwrite the `ENTRYPOINT`.

```
FROM mjuenema/alpine-linux

COPY peervpn.conf /etc/peervpn.conf

ENTRYPOINT ['/sbin/peervpn.conf', '/etc/peervpn.conf']
```

## Author

Markus Juenemann <markus@juenemann.net>

## Changelog

### `0.1`

Initial version.
