---
title: Examples
description: Examples
---

# Examples

The [code excerpts][] that appear in the Dart and Flutter sites are extracted
from the source files contained in the site repo's `examples` folder. The folder
is organized as a collection of projects.

As part of [CI][], project sources are:

- Format-checked (using `dart format` or `flutter format`)
- Analyzed (using `dart analyze` or `flutter analyze`)
- Tested (test files are under `examples/*/test`; run with `dart test`
or `flutter test`)

By doing so we ensure that our code excerpts are valid Dart code.

## How should I organize my example code?

Organize our example code like any other Dart project, placing source files under the following folders:

- `examples/my_example_project/lib`
- `examples/my_example_project/test`

## Should I write a test for my example code?

While all source code is format-checked and analyzed, only some portions warrant
testing. For example, a code excerpt that merely illustrates syntax, such as the
following, doesn't need to be tested.

```dart
var list = [1, 2, 3]; // A list literal
```

On the other hand, code that is part of a multi-step tutorial often has at least
a smoke test for each step. For code of intermediate complexity often has a
small collection of associated unit tests.

Write your tests just as you would for a regular Dart/Flutter project. Also see
[How do I write a test for my code excerpt?][].

## Can I check my code for analyzer hint / warning / errors?

The [site-www][] has a basic setup that allows you to expect specific analyzer
output. (This functionality has yet to be shared across other sites.)

For more information see [How do I update the analyzer results files?][].

## Where's the CI script used to check example code?

Most repos use a script named `./tool/check-code.sh`.

[CI]: https://www.thoughtworks.com/continuous-integration
[code excerpts]: code-excerpts.md
[How do I update the analyzer results files?]: https://github.com/dart-lang/site-www/tree/master/examples#how-do-i-update-the-analyzer-results-files
[site-www]: https://github.com/dart-lang/site-www
[How do I write a test for my code excerpt?]: code-excerpts.md#how-do-i-write-a-test-for-my-code-excerpt
