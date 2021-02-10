#!/usr/bin/env bash

set -e -o pipefail

source ./tool/shared/env-set-check.sh
source ./tool/shared/_robots.sh

function _usage() {
  echo "Usage: $(basename $0) [options] firebase-project-name";
  echo
  echo "  --local|-l     Locally deploy from an interactive shell where you are"
  echo "                 already logged in with firebase."
  echo
  echo "  --quiet|-q     Generate no more output than what the firebase-tools generates on deploy."
  echo
  robotsOptionsUsage
  exit 0
}

while [[ "$1" == -* ]]; do
  case "$1" in
    --firebase)   SERVE="npx firebase serve"; shift;;
    --help|-h)    _usage;;
    --local|-l)   LOCAL=1; shift;;
    --quiet|-q)   QUIET=1; shift;;
    --robots)     shift; ROBOTS="$1"; shift;;
    *)            _error "Unrecognized option: $1. Use --help for details.";;
  esac
done

_ARGS=""
_FB_PROJ=$1

if [[ -z $_FB_PROJ ]]; then
  _error "No firebase project specified. Use --help for details?"
fi

if [[ -z $LOCAL && -z "$FIREBASE_TOKEN" ]]; then
  _error "Cannot deploy, the FIREBASE_TOKEN environment variable isn't defined. Did you mean to use --local? Use --help for details."
elif [[ -z $LOCAL ]]; then
  _ARGS+=" --non-interactive"
fi

_ARGS+=" --project $_FB_PROJ"

if [[ -z $ROBOTS && _FB_PROJ == default ]]; then
  echo "When deploying to 'default' you must explicitly specify the robots"
  echo "option: --robots <RS>. Use --help for details."
  exit 1;
fi

function _cleanup() {
  echo "Cleaning up:"
  restoreRobotsTxt
}

trap "echo; echo 'Signal trapped.'; exit 130" SIGINT SIGTERM
trap "_cleanup" EXIT # original exit code is preserved

saveAndSetRobotsTxt $ROBOTS
printRobotsTxt

[[ -z $QUIET ]] && echo "Deploying to Firebase project: $_FB_PROJ"
(
  set -x
  npx firebase --version
  npx firebase deploy $_ARGS
)
