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

# Ruby-2.6.x comes with bundler version 1.17.3.
# For earlier versions of ruby, get the bundler gem v1.17.3.
# Once all sites have migrated to the use of ruby 2.6,
# then the if statement and the bundle --version can be deleted
if [[ -z "$(type -t bundle)" || "$(bundle --version)" < 'Bundler version 1.17.3' ]]; then
  travis_fold start before_install.ruby_bundler
    (set -x; gem install bundler -v 1.17.3)
  travis_fold end before_install.ruby_bundler
fi
bundle --version

./tool/shared/install-dart-sdk.sh

if [[ -n "$FORCE" ]]; then
  : ${PUB_CMD:=upgrade}
fi

travis_fold start before_install.pub
  # For now favor running pub upgrade so that we can get the latest code_* packages
  # (which are specified in the pubspec via overrides):
  pub ${PUB_CMD:-upgrade}
travis_fold end before_install.pub
