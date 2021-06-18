# Changelog

## 1.0.0

- When YAML excerpt files are generated, the excerpt values
  are now multiline strings with a left border character as
  the first character of each line. The value of the special
  map key '#border' is the border character. (The code-excerpt
  updater trims of this border character when present.)

## 0.6.2

- Internal changes (ran format --fix).

## 0.6.1

- Don't process dot files.

## 0.6.0

- Upgrade to v1 of `builder` and `build_runner`.

## 0.5.0

- Set max SDK version to <3.0.0.

## 0.4.1

- Updated README to explain usage, syntax, etc.
- Set min SDK to 2.0.0-dev.67.0 and upgrade `build_runner` to 0.9.0.

## 0.4.0

- Set min SDK to 2.0.0-dev.64.1 and upgrade `test` to 1.0.0.

## 0.3.1+1, +2

- Set min SDK to 2.0.0-dev.61 and other package version downgrades.

## 0.3.1

- Fix type error.
- Set min SDK to 2.0.0-dev.62

## 0.3.0

- Change base config so that the builder applies to all packages
  (via `auto_apply: all_packages`).

## 0.2.0

- Support quoted default region name `''`, and deprecate
  unquoted default region name usage.
- Warn about repeated region names.

## 0.1.0

- First public version, inspired by JavaScript-based
  [github.com/chalin/code-excerpter](https://github.com/chalin/code-excerpter),
  which was derived from tooling used under angular.io.

