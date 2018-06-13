#!/usr/bin/env bash

set -e -o pipefail

[[ -z "$DART_SITE_ENV_DEFS" ]] && . ./scripts/env-set.sh

PORT=$SITE_LOCALHOST_PORT
CHECK_EXIT_CODE=0

if [ ! -e "publish" ]; then
  echo "Site not built, skipping link check."
  exit $CHECK_EXIT_CODE
fi

set -x
((superstatic --port $PORT > /dev/null  2>&1) \
  || echo "Failed to launch superstatic server. Maybe it is already running?") &
SERVER_PID=$!

sleep 4

# Don't check for external links yet since it seems to cause problems on Travis: --external
pub run linkcheck \
  --skip-file ./scripts/config/linkcheck-skip-list.txt \
  :$PORT \
  | tee $TMP/linkcheck-log.txt

set +x

if ! grep '^\s*0 errors' $TMP/linkcheck-log.txt | wc -l > /dev/null; then
  CHECK_EXIT_CODE=1
fi

kill $SERVER_PID

exit $CHECK_EXIT_CODE
