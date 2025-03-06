#!/usr/bin/env bash

missing_secret () {
  echo 'ERROR: secrets not set; abort startup' >&2
  exit 1
}

[[ -n "${UDP_DOMAIN}" ]] || missing_secret
[[ -n "${UDP_IDM_CLIENT_ID}" ]] || missing_secret
[[ -n "${UDP_IDM_CLIENT_SECRET}" ]] || missing_secret
[[ -n "${UDP_IDM_REALM}" ]] || missing_secret
[[ -n "${UDP_PASSWORD}" ]] || missing_secret
[[ -n "${UDP_USERNAME}" ]] || missing_secret

dagster api grpc --host 0.0.0.0 --port 80 -m utils.dagster.definitions
