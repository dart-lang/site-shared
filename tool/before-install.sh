#!/usr/bin/env bash

set -e -o pipefail

source ./tool/shared/env-set-check.sh

while [[ "$1" == -* ]]; do
  case "$1" in
    --get)      PUB_CMD=get; shift;;
    -h|--help)  echo "Usage: $(basename $0) [options]";
                echo
                echo "  --get       Run `dart pub get` for the current repo. Default is pub upgrade."
                echo "  --help      Print this usage text."
                exit 0;;
    *)          echo "ERROR: Unrecognized option: $1. Use --help for details.";
                exit 1;;
  esac
done

if [[ -n "$CI" && -e ./tool/env-info-and-check.sh ]]; then
  ./tool/env-info-and-check.sh
fi

./tool/shared/install-dart-sdk.sh

echo "::group::before_install.pub"
  # For now favor running pub upgrade so that we can get the latest code_* packages
  # (which are specified in the pubspec via overrides):
  dart pub ${PUB_CMD:-upgrade}
echo "::endgroup::"
