#!/usr/bin/env bash

set -e -o pipefail

# Assume that this script will be linked to ~/tool/foo the parent repo.
cd `dirname $0`/..

SERVE="npx superstatic"
JEKYLL_OPTS="--incremental --watch "

while [[ "$1" == -* ]]; do
  case "$1" in
    --clean)    CLEAN=1; shift;;
    --dev)      FILE=_config_dev.yml
                if [[ -e $FILE ]]; then
                  CONFIG=",$FILE$CONFIG"
                else
                  echo "Warning: $1 option ignored because $FILE not found"
                fi
                shift;;
    --firebase) SERVE="npx firebase serve";
                shift;;
    -h|--help)  echo "Usage: $(basename $0) [options]";
                echo
                echo "  --clean     Delete generated site files before (re-)building the site."
                echo "  --dev       Build using _config_dev.yml."
                echo "  --firebase  Serve using firebase rather than superstatic."
                echo "  --help      Print this usage text."
                echo "  --pin-now   Build using _config_now.yml."
                echo "  --trace     Run jekyll build with --trace."
                exit 0;;
    --pin-now)  FILE=_config_now.yml
                if [[ -e $FILE ]]; then
                  CONFIG=",$FILE$CONFIG"
                else
                  echo "Warning: $1 option ignored because $FILE not found"
                fi
                shift;;
    --trace)    JEKYLL_OPTS+="--trace ";
                shift;;
    *)          echo "ERROR: Unrecognized option: $1. Use --help for details.";
                exit 1;;
  esac
done

echo "$0: for details about command-line options, use --help"
echo

if [[ -n $CONFIG ]]; then
  CONFIG="--config _config.yml$CONFIG"
fi

if [[ -n $CLEAN ]]; then
  CLEAN_TARGETS=''
  if [[ -e "$SITE_JEKYLL_DEST" ]]; then
    # Clean out the folder w/o deleting it since in some setups it's a symlink
    CLEAN_TARGETS+="$SITE_JEKYLL_DEST/* "
  else
    echo "WARNING: $SITE_JEKYLL_DEST doesn't exist, so there is nothing to clean."; echo
  fi
  CLEAN_TARGETS+="$SITE_JEKYLL_SRC/.jekyll-* "
fi

if [[ -n $CLEAN_TARGETS ]]; then
  (set -x; rm -Rf $CLEAN_TARGETS)
fi

(set -x; bundle exec jekyll build $CONFIG $JEKYLL_OPTS) &
j_pid=$!
(set -x; $SERVE --version; $SERVE --port ${SITE_LOCALHOST_PORT:-5000}) &
f_pid=$!
echo "Cached PIDs for build and serve: $j_pid, $f_pid"
trap "{ kill $j_pid; kill $f_pid; exit 0; }" SIGINT SIGTERM
wait
