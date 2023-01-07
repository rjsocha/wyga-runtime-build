#!/bin/sh
PMA_SQL="$(gzip -9c create_tables.sql | base64 -w 0)"
echo "PMA_SQL=\"${PMA_SQL}\""
cat pma-init.sh.in
