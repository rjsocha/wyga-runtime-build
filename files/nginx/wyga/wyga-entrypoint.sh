#!/bin/sh
/usr/local/bin/env-conf
exec /docker-entrypoint.sh "$@"
