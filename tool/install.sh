#!/usr/bin/env bash

set -e -o pipefail

source ./tool/shared/env-set-check.sh

cd `dirname $0`/..

if [[ "$(node --version)" < "v$_DART_SITE_NODE_VERS" ]]; then
    echo "ERROR: bad version of node detected. If you have nvm installed, type:"
    echo "  nvm use"
    echo "Aborting installation."
    exit 1;
else
    echo "Node version: $(node --version)"
fi

echo "::group::install.npm_install"
  (set -x; npm install)
echo "::endgroup::"

if [[ -z "$CI" || "$TASK" == *build* ]]; then
  echo "::group::install.bundle"
    bundle --version
    (set -x; bundle install)
  echo "::endgroup::"
fi
