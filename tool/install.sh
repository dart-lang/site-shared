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

travis_fold() { true; }

travis_fold start install.npm_install
  (set -x; npm install)
travis_fold end install.npm_install

if [[ -z "$TRAVIS" || "$TASK" == *build* ]]; then
  travis_fold start install.bundle
    bundle --version
    (set -x; bundle install)
  travis_fold end install.bundle
fi
