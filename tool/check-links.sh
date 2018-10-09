#!/usr/bin/env bash

set -e -o pipefail

source ./tool/shared/env-set-check.sh
source ./tool/shared/_robots.sh

PORT=${SITE_LOCALHOST_PORT:-5000}
SERVE_CMD="superstatic"
ARGS=''

if [ ! -e "./$SITE_JEKYLL_DEST" ]; then
  echo "INFO: $SITE_JEKYLL_DEST directory not found. Site not built? Skipping link checks."
  exit 0
fi

while [[ "$1" == -* ]]; do
  case "$1" in
    --external|-e) ARGS+="$1 "; shift;;
    --firebase) SERVE_CMD="firebase serve"; shift;;
    --help|-h)  echo "Usage: $(basename $0) [options]"
                echo
                echo "  --external  Also check external links."
                echo "  --firebase  Use firebase instead of superstatic to serve the site."
                echo "  --port P    Serve on port P."
                echo "  --quiet"
                echo
                robotsOptionsUsage
                exit 0;;
    --port)     shift; PORT=$1; shift;;
    --quiet|-q) QUIET=1; shift;;
    --robots)   shift; ROBOTS="$1"; shift;;
    *)          _error "Unrecognized option: $1. Use --help for details.";
                exit 1;;
  esac
done

function _cleanup() {
  echo "Cleaning up:"
  restoreRobotsTxt

  # Kill server
  if [[ -z $SERVER_PID ]]; then
    echo "+ No server process ID was registered"
  elif kill -0 $SERVER_PID > /dev/null 2>&1; then
    CMD="kill -9 $SERVER_PID"
    echo "+ $CMD (server process)"
    $CMD;
  else
    echo "+ Server process already stopped"
  fi
}

trap "echo; echo 'Signal trapped.'; _cleanup" SIGINT SIGTERM
trap "_cleanup" EXIT # original exit code is preserved

saveAndSetRobotsTxt $ROBOTS

# Attempt to launch the server.
#
# NOTE: We can't do the usual `(set -x; ...)` trick because we'd lose the
# ability to get the server PID.

CMD="npx $SERVE_CMD --port $PORT"
echo "+ $CMD"
$CMD > "$TMP/linkcheck-server-log.txt" 2>&1 &
SERVER_PID=$!
echo "  Server PID: $SERVER_PID"

sleep 2; [[ -z "$TRAVIS" ]] && sleep 2

if ! kill -0 $SERVER_PID > /dev/null 2>&1; then
  echo; echo "WARNING: Failed to launch '$SERVE_CMD' (output is in $TMP/linkcheck-server-log.txt). I'll assume it is already running."
  if [[ -n "$TRAVIS" ]]; then
    echo "Here's the log with errors (that we're ignoring):"; echo
    cat "$TMP/linkcheck-server-log.txt"
  fi
  echo
  SERVER_PID=
fi

# printRobotsTxt

# Don't check for external links yet since it seems to cause problems on Travis: --external
CMD="pub run linkcheck $ARGS--skip-file ./tool/config/linkcheck-skip-list.txt :$PORT"
echo "+ $CMD"
$CMD | tee "$TMP/linkcheck-log.txt"

# Set this scripts exit code based on grep:
grep -qe '^\s*0 errors' "$TMP/linkcheck-log.txt"
