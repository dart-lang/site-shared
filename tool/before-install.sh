#!/usr/bin/env bash

set -e -o pipefail

source ./tool/shared/env-set-check.sh

while [[ "$1" == -* ]]; do
  case "$1" in
    --force)    FORCE=1; shift;;
    --get)      PUB_CMD=get; shift;;
    -h|--help)  echo "Usage: $(basename $0) [options]";
                echo
                echo "  --force     Force install all, even if already present."
                echo "  --get       Run pub get for the current repo. Default is pub upgrade."
                echo "  --help      Print this usage text."
                exit 0;;
    *)          echo "ERROR: Unrecognized option: $1. Use --help for details.";
                exit 1;;
  esac
done

if [[ -n "$TRAVIS" && -e ./tool/env-info-and-check.sh ]]; then
  ./tool/env-info-and-check.sh
fi

# Jekyll needs Ruby and the Ruby bundler
travis_fold start before_install.ruby_bundler
  if [[ -n "$TRAVIS" || -n "$FORCE" || -z "$(type -t bundler)" ]]; then
    (set -x; gem install bundler)
  else
    echo "Bundler already installed. Use --force to reinstall/update."
  fi
travis_fold end before_install.ruby_bundler

./tool/shared/install-dart-sdk.sh

if [[ -n "$FORCE" ]]; then
  : ${PUB_CMD:=upgrade}
fi

travis_fold start before_install.pub
  # For now favor running pub upgrade so that we can get the latest code_* packages
  # (which are specified in the pubspec via overrides):
  pub ${PUB_CMD:-upgrade}
travis_fold end before_install.pub
