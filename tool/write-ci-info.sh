#!/usr/bin/env bash

FILE=src/_data/ci.yaml

echo "# WARNING: the values in this file get regenerated at build time.
build-id: ${GITHUB_RUN_ID:-$TRAVIS_BUILD_ID}
build-number: ${GITHUB_RUN_NUMBER:-$TRAVIS_BUILD_NUMBER}
build-time: $(date)
commit-sha: ${GITHUB_SHA:-$TRAVIS_COMMIT}
job-id: ${GITHUB_RUN_ID:-$TRAVIS_JOB_ID}
repo-slug: ${GITHUB_REPOSITORY:-$TRAVIS_REPO_SLUG}" > $FILE

if [[ "$1" == '-v' ]]; then
  echo "$FILE:"
  cat $FILE
fi
