#!/usr/bin/env bash

pub run build_runner build --config example --output=build

if diff -r build build_expected | grep -Ev "^Only in "; then
  echo
  echo "Unexpected builder output! See diff details above."
  exit 1;
else
  exit 0;
fi
