# Changelog

## 1.1.1

- Support YAML excerpt files with a specified excerpt border character as the
  value of the `#border` map key. If present, all code excerpt lines will be
  assumed to be prefixed withe the border character in the YAML file. The
  app will strip out the border before updating docs with excerpt code.
  
  Here is a sample YAML excerpt file:
  
    ```yaml
    '#border': '|'
    'main': |+
      |void main() => print('$greeting $scope');
    ```

  Note the leading `|` as the first character of the `main` code excerpt. 

## 1.1.0 - unpublished

## 1.0.1

- Bug fix: reintroduce support for empty plaster string argument.

## 1.0.0

- First Dart-2-only release. No code changes.

## 0.19.2

- Last Dart 1 compatible version.
- Add `--log-fine` option.

## 0.19.1

- Support `remove` argument for diff instructions.

## 0.19.0

- Support `skip="+/-n"` and `take="+/-n"` arguments.

## 0.18.1

- Support `from` and `to` for non-diff code-excerpt instructions.

## 0.18.0

- BREAKING CHANGE: Respect code-excerpt instruction argument order.

## 0.17.1, 0.17.2

- Internal refactoring: e.g., use `Matcher` rather than `RegExp` as diff argument types.

## 0.17.0

- As an alternative to the `diff-with` argument, add support for the Bash path
  brace syntax.

## 0.16.1

- Code refactorings.

## 0.16.0

- Fully support the diff `from` argument.

## 0.15.0

- Support `diff-u="NUM"` arguments for diff instructions.

## 0.14.0

- Support diff of code regions.

## 0.13.0

- Remove docregion tags from diff source files before performing the diff (#40).

## 0.12.0

- Support code blocks between `{% foo ... %}` and `{% endfoo %}`.
  This has been added, in particular to support `diff` tags.

## 0.11.0

- Support `--exclude=<PATH_REGEXP,...>`.

## 0.10.1

- Fix type error.

## 0.10.0

- Command returns a non-zero exit code if errors occur during file processing,
  or if fragments were refreshed and `--fail-on-refresh` is requested.

## 0.9.2

- Cleanup of pubspec package dependencies.

## 0.9.1

- Support globally set plaster template using command line option `--plaster TEMPLATE`,
  and plaster as a set instruction.

## 0.9.0

- Support reading excerpts from `*.excerpt.yaml` files when the new `--yaml` flag is used.
- Support `plaster` attributes. For legacy excerpts, only `plaster="none"` is recognized.

## 0.8.1

- Support `code-excerpt` instructions as the first line
  in a markdown list that starts with `-` or `*`.

## 0.8.0

- Deprecate processing instruction syntax without `?` before the closing `>`.
- Support strip-whitespace syntax `{%-...-%}` for prettify tags.

## 0.7.2

- Accept `{% prettify %}` with more than one argument.

## 0.7.1

- Strictly match code block marker start/end kinds.
  E.g., now only `{% endprettify %}` is accepted as
  the end of a prettify code block (not a triple backtick).
  In this way prettify blocks can contain triple backtick markers.

## 0.7.0

- Support `code-excerpt` `remove` attribute.

## 0.6.1

- Add `class` as a recognized `code-excerpt` attribute.

## 0.6.0

- Support `code-excerpt` `retain` attribute.
- Report an error for unrecognized `code-excerpt` attributes.

## 0.5.3

- Don't warn about instructions having a `class`
  argument but no `title` since these are processed
  by other tools.

## 0.5.2

- Support the `--replace="/.../.../g; ..."` command line option.

## 0.5.1

- Support the following special characters in replace arguments:
  `\t`, `\n`, and hexadecimal character codes `\xHH`.

## 0.5.0

- Support global replace instruction.

## 0.4.1

- Fix: a `replace` regexp with `}`  would break the parsing of `code-excerpt` args.

## 0.4.0

- Support multiple semi-colon separated "/foo/bar/g" expressions as arguments to `replace`.

## 0.3.1

- Support escaped backslash characters (`\/`) in the replace expression of
  replace attributes; e.g., `replace="/(foo)/$&\/bar/g"` will replace
  `foo` by `foo/bar`.

## 0.3.0

- Add support for code blocks braced between `{% prettify opt-lang %}` and
  `{% endprettify %}`, as used in site-www.
- Add support for `$&` is replacement expressions of the `replace` attribute.

## 0.2.0

- Add support for `code-excerpt` `replace` attributes having arguments of the form
  **/_regex_/_replacement_/g**. Like in JavaScript, _replacement_ can contain
  match capture placeholders `$1`, `$2`, etc. `$$` escapes `$`.

## 0.1.0

- When a code excerpt consists of an entire file, and no corresponding fragment
  file is found, an attempt is made to find the file in source directory.
- Any `#docregion` tags that appear in file diffs are filtered.

## 0.0.1

- First public version, based on
  [github.com/chalin/api_doc_updater](https://github.com/chalin/api_doc_updater).

