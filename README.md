# MediaWiki Parsoid with Docker

[![Docker Pulls](https://img.shields.io/docker/pulls/thenets/parsoid.svg?style=flat-square)](https://hub.docker.com/r/thenets/parsoid/) [![Build Status](https://travis-ci.org/thenets/docker-parsoid.svg?branch=master)](https://travis-ci.org/thenets/docker-parsoid)

> ‼ In MediaWiki 1.35 LTS Parsoid/PHP is included in the bundle and loaded automatically by Visual Editor. No configuration necessary if used on a single server.
> Check official documentation if you're using a new MediaWiki version: https://www.mediawiki.org/wiki/Parsoid#Installation

This repo contains a [Docker](https://docs.docker.com/) image to run the [Parsoid](https://www.mediawiki.org/wiki/Parsoid) old application version (0.8 ~ 0.11). See the full [Parsoid/Setup documentation](https://www.mediawiki.org/wiki/Parsoid/Setup#Docker) for help.

## Versions available

`thenets/parsoid:0.8`, `thenets/parsoid:0.9`, `thenets/parsoid:0.10`, `thenets/parsoid:0.11`

## What Is Included?
- Alpine
- Parsoid

## How to deploy
To start [Parsoid](https://www.mediawiki.org/wiki/Parsoid) run the command below. Just pay attention to the MediaWiki version and choose a compatible Parsoid version.

```
# For MediaWiki <= 1.30
docker run -d -p 8080:8000 -e PARSOID_DOMAIN_localhost=http://localhost/w/api.php thenets/parsoid:0.8

# For MediaWiki >= 1.31 & <= 1.32
docker run -d -p 8080:8000 -e PARSOID_DOMAIN_localhost=http://localhost/w/api.php thenets/parsoid:0.10

# For MediaWiki >= 1.33
docker run -d -p 8080:8000 -e PARSOID_DOMAIN_localhost=http://localhost/w/api.php thenets/parsoid:0.11
```

## Examples

How to add more than one domain:

```
docker run -d -p 8080:8000 \
            -e PARSOID_DOMAIN_foobar=http://foobar.com/w/api.php \
            -e PARSOID_DOMAIN_example=http://example.com/w/api.php \
            -e PARSOID_DOMAIN_localhost=http://localhost/w/api.php \
            thenets/parsoid:0.11
```

How to expose on a specific port: (You can use arbitrary port numbers which are not already in use)

```
# Expose port 8081
docker run -d -p 8081:8000 -e PARSOID_DOMAIN_localhost=http://localhost/w/api.php thenets/parsoid:0.11

# Expose port 8142
docker run -d -p 8142:8000 -e PARSOID_DOMAIN_localhost=http://localhost/w/api.php thenets/parsoid:0.11
```

## Settings (ENV vars)

- `PARSOID_DOMAIN_{domain}` defines URI and domain for the Parsoid service. The value of `{domain}` should be the same as the `MW_REST_DOMAIN` parameter in the MediaWiki web container. You can specify such variables multiple times (one for each domain the service should run for)
- `PARSOID_NUM_WORKERS` defines the number of worker processes to the parsoid service. Set to `0` to run everything in a single process without clustering. Use `ncpu` to run as many workers as there are CPU units.
- `PARSOID_LOGGING_LEVEL` by default `info`
- `PARSOID_STRICT_SSL` by default `true` [`true`, `false`]

For example, the environment variable `PARSOID_DOMAIN_web=http://web/w/api.php` creates following section in the Parsoid configuration:
```
mwApis:
  -
    uri: 'http://web/w/api.php'
    domain: 'web'
```

## Thanks

- [pastakhov](https://github.com/pastakhov): Creator of the original code base.
- [muellermartin](https://github.com/muellermartin): Improved the documentation.
- [endoodev1](https://github.com/endoodev1): Helped with Kubernetes compatibility.
- [sepastian](https://github.com/sepastian): Added support to `strictSSL` using container ENV.
