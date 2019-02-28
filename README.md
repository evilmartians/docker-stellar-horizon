# Stellar Horizon Docker image

This is a smiple Docker image of Stellar Horizon. This image was originally based on [satoshipay/docker-stellar-horizon](https://github.com/satoshipay/docker-stellar-horizon) but we build static Stellar Horizon binary by ourselves to provide a smaller busybox-based final Docker Image.

## How to get

```shell
docker pull mobiusnetwork/stellar-horizon:0.17.2
```

## Configuration

It is intended to be configured via Stellar Horizon environment variables:

* `PORT` - tcp port to listen on for http requests (default: `8000`);
* `DATABASE_URL` - horizon postgres database to connect with;
* `STELLAR_CORE_DATABASE_URL` - stellar-core postgres database to connect with;
* `STELLAR_CORE_URL` - stellar-core to connect with (for http commands);
* `PER_HOUR_RATE_LIMIT` - max count of requests allowed in a one hour period, by remote ip address (default `3600`);
* `REDIS_URL` - redis to connect with, for rate limiting;
* `FRIENDBOT_URL` - friendbot service to redirect to;
* `LOG_LEVEL` - minimum log severity (debug, info, warn, error) to log (default `info`);
* `SENTRY_DSN` - sentry URL to which panics and errors should be reported;
* `LOGGLY_TOKEN` - Loggly token, used to configure log forwarding to loggly;
* `LOGGLY_HOST` - Hostname to be added to every loggly log event;
* `TLS_CERT` - the TLS certificate file to use for securing connections to horizon;
* `TLS_KEY` - the TLS private key file to use for securing connections to horizon;
* `INGEST` - causes this horizon process to ingest data from stellar-core into horizon's db (default `false`);
* `INGEST_FAILED_TRANSACTIONS` - causes this horizon process to ingest failed transactions data;
* `ENABLE_ASSET_STATS` — enables asset stats during the ingestion and expose /assets endpoint;
* `NETWORK_PASSPHRASE` - override the network passphrase;
* `HISTORY_RETENTION_COUNT` - the minimum number of ledgers to maintain within horizon's history tables.  0 signifies an unlimited number of ledgers will be retained;
* `HISTORY_STALE_THRESHOLD` - the maximum number of ledgers the history db is allowed to be out of date from the connected stellar-core db before horizon considers history stale;
* `SKIP_CURSOR_UPDATE` - skip DB cursor update;

There are two additional variables. They are optional and can be used to provide passwords separately (e.g., via Kubernetes secrets):

* `DATABASE_PASSWORD`: if it is provided the string `DATABASE_PASSWORD` in `DATABASE_URL` will be replaced with its value.
* `STELLAR_CORE_DATABASE_PASSWORD`: if it is provided the string `STELLAR_CORE_DATABASE_PASSWORD` in `STELLAR_CORE_DATABASE_URL` will be replaced with its value.

Read more about Stellar Horizon administration in the [official docs](https://github.com/stellar/go/blob/master/services/horizon/internal/docs/reference/admin.md)
