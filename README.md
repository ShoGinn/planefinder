# planefinder
Docker container for ADS-B - This is the planefinder.net component

This is part of a suite of applications that can be used if you have a dump1090 compatible device including:
* Any RTLSDR USB device
* Any network AVR or BEAST device
* Any serial AVR or BEAST device

# Container Requirements

This is a multi architecture build that supports arm (armhf/arm64) and amd64

You must first have a running setup for before using this container as it will not help you on initial setup

# Container Setup

Env variables must be passed to the container containing the planefinder.net required items

### Defaults
* DUMP1090_SERVER=dump1090 -- make sure your dump1090 container is named this and on the same network
* DUMP1090_PORT=30005 -- default port
* Port 30053/tcp is exposed for its really nice web ui

### User Configured
* PLANEFINDER_LATITUDE - Decimal format latitude of your ADSB Antenna
* PLANEFINDER_LONGITUDE - Decimal format longitude of your ADSB Antenna
* PLANEFINDER_SHARECODE - Your Planefinder.net sharecode

#### Example docker run

```
docker run -d \
--restart unless-stopped \
--name='planefinder' \
-p 30053:30053 \
-e PLANEFINDER_LATITUDE="36.000" \
-e PLANEFINDER_LONGITUDE="-115.000" \
-e PLANEFINDER_SHARECODE="2340dsfkl" \
shoginn/planefinder:latest-amd64

```
# Status
| branch | Status |
|--------|--------|
| master | [![Build Status](https://travis-ci.org/ShoGinn/planefinder.svg?branch=master)](https://travis-ci.org/ShoGinn/planefinder) |

| Arch | Size/Layers | Commit |
|------|-------------|--------|
[![](https://images.microbadger.com/badges/version/shoginn/planefinder:latest-arm.svg)](https://microbadger.com/images/shoginn/planefinder:latest-arm "Get your own version badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/shoginn/planefinder:latest-arm.svg)](https://microbadger.com/images/shoginn/planefinder:latest-arm "Get your own image badge on microbadger.com") | [![](https://images.microbadger.com/badges/commit/shoginn/planefinder:latest-arm.svg)](https://microbadger.com/images/shoginn/planefinder:latest-arm "Get your own commit badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/shoginn/planefinder:latest-arm64.svg)](https://microbadger.com/images/shoginn/planefinder:latest-arm64 "Get your own version badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/shoginn/planefinder:latest-arm64.svg)](https://microbadger.com/images/shoginn/planefinder:latest-arm64 "Get your own image badge on microbadger.com") | [![](https://images.microbadger.com/badges/commit/shoginn/planefinder:latest-arm64.svg)](https://microbadger.com/images/shoginn/planefinder:latest-arm64 "Get your own commit badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/shoginn/planefinder:latest-amd64.svg)](https://microbadger.com/images/shoginn/planefinder:latest-amd64 "Get your own version badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/shoginn/planefinder:latest-amd64.svg)](https://microbadger.com/images/shoginn/planefinder:latest-amd64 "Get your own image badge on microbadger.com") | [![](https://images.microbadger.com/badges/commit/shoginn/planefinder:latest-amd64.svg)](https://microbadger.com/images/shoginn/planefinder:latest-amd64 "Get your own commit badge on microbadger.com")

