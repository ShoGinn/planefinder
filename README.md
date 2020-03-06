# planefinder

Docker container for ADS-B - This is the planefinder.net component

This is part of a suite of applications that can be used if you have a dump1090 compatible device including:

* Any RTLSDR USB device
* Any network AVR or BEAST device
* Any serial AVR or BEAST device

## Container Requirements

This is a multi architecture build that supports arm (armhf/arm64) and amd64

You must first have a running setup for before using this container as it will not help you on initial setup

## Container Setup

Env variables must be passed to the container containing the planefinder.net required items

### Defaults

* DUMP1090_SERVER=dump1090 -- make sure your dump1090 container is named this and on the same network
* DUMP1090_PORT=30005 -- default port
* Port 30053/tcp is exposed for its really nice web ui

### User Configured

* DUMP1090_LAT - Decimal format latitude of your ADSB Antenna
* DUMP1090_LON - Decimal format longitude of your ADSB Antenna
* PLANEFINDER_SHARECODE - Your Planefinder.net sharecode

#### Example docker run

```bash
docker run -d \
--restart unless-stopped \
--name='planefinder' \
-p 30053:30053 \
-e DUMP1090_LAT="36.000" \
-e DUMP1090_LON="-115.000" \
-e PLANEFINDER_SHARECODE="2340dsfkl" \
shoginn/planefinder:latest

```

## Status

| branch | Status |
|--------|--------|
| master | [![Build Status](https://travis-ci.org/ShoGinn/planefinder.svg?branch=master)](https://travis-ci.org/ShoGinn/planefinder) |
