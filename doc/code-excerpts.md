---
title: Code excerpts
description: Code excerpts
---

# Code excerpts

Many site pages contain code excerpts, and these excerpts are kept in sync with
their originating [examples][] source file by use of the tools mentioned in this
page.

# How do I ...

This page answers the most common "how-to" questions related to code excerpts.

## How do I associate a code block with its source?

To associate a markdown code block with (a region of) a source file, use a
`<?code-excerpt?>` [processing instruction][] (or two). Here is an example taken
from [src/docs/development/ui/interactive.md][] (flutter/website):

    <?code-excerpt "layout/lakes/interactive/lib/main.dart (FavoriteWidget)"?>
    ```dart
    class FavoriteWidget extends StatefulWidget {
      @override
      _FavoriteWidgetState createState() => _FavoriteWidgetState();
    }
    ```

The excerpted code comes from the region named `FavoriteWidget` in the file
[layout/lakes/interactive/lib/main.dart][]. Regions are marked using the
`#docregion` syntax. For example:

```dart
...
// #docregion FavoriteWidget
class FavoriteWidget extends StatefulWidget {
  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}
// #enddocregion FavoriteWidget
...
```

## What's the syntax for instructions and docregions?

For the full instruction syntax, see [\<?code-excerpt?> syntax][], from the
[code_excerpt_updater][] tool README. For information about `docregion`s see the
[code_excerpter][] tool README.

The tools have several useful features (not covered here), to help make your
life easier. For example, if all of the files in your page come from a single
folder, which can often be the case, then you can set the path base once, and
then use relative file paths in subsequent instructions, like this:

    <?code-excerpt path-base="layout/lakes/interactive"?>
    ...
    <?code-excerpt "lib/main.dart (FavoriteWidget)"?>
    ```dart
    // Some code
    ```

<a id="refresh"></a>
## How do I know if the code excerpts are fresh / synced?

Use the `./tool/refresh-code-excerpts.sh` script to ensure that in-page code
excerpts are fresh relative to the source files that they are extracted from.

The refresh script uses the following tools under the hood:

 1. [code_excerpter][] scans all source files and creates code excerpt files.
 2. [code_excerpt_updater][] scans the site pages, and refreshes code excerpts
    using the generated excerpt files.

## How do I edit an existing code excerpt?

You're working on a site page and you've found a code excerpt that needs to be
updated? Trace the excerpt back to its origin and make the changes in the
originating source. Then run the code-excerpt [refresh script](#refresh).

## How do I add a new excerpt to an existing example file

 1. Locate the source file.
 1. Identify the code region in that file.
 1. Choose a region name.
 1. Add `#docregion <region-name>` `#enddocregion <region-name>` tags.

## Can I excerpt an entire source file?

To excerpt an entire source file simply omit the region name from the processing
instruction.

> **Note:** When you omit the region name, it defaults to `''`, the empty region name.

> **Pro tip:** By default, the empty region name (`''`) corresponds to the
> entire file, but you can change that by using explicit `docregion` tags with
> `''` as a region name argument.

## How do I write a test for my code excerpt?

**Related:** [Should I write a test?][].

As is customary, test files live under `examples/my_example_project/test`.

If your code excerpt is small, embedded your code excerpt (bracketed by
`docregion` tags) directly in the test like this [hello-world example][]:

```dart
  test('hello world', () {
    // #docregion hello-world
    void main() {
      print('Hello, World!');
    }

    // #enddocregion hello-world
    expect(main, prints('Hello, World!\n'));
  });
```

If you are testing lots of code used, for example, as part of a tutorial, then
follow the recommended Dart practice of placing project code (with `docregion`
tags) under `lib`, and tests under `test`.


## Some code excerpts contain `[!...!]`, what's that?

Code enclosed in the special syntax `[!...!]` will be highlighted.

For example, the code

```
int [!foo!] = 1;
```

will display as

> <code>int <mark>foo</mark> = 1;</code>

**Legacy:** Markers like `[[highlight]]...[[/highlight]]` and
`[[strike]]...[[/strike]]` (and more) are still supported in some repos.

## How can I highlight part of a code excerpt

Since code excerpts are synced, you can't embed the highlight markers by hand.
Instead use the `replace` argument, for example:

    <?code-excerpt "bar/foo.dart" replace="/foo/[!$&!]/g"?>
    ```
    int [!foo!] = 1;
    ```

> **Note:** `$&` is the [regular expression][] syntax corresponding to the fully
> string that was matched. Groups and the group match syntax, such as `$1`,
> `$2`, etc. are also supported.

For more information about the `replace` argument syntax see
[code_excerpt_updater][].

# Advanced features

## Embellished code excerpts

In some repos, code excerpts not only serve to associate a code block with its
originating source, but the processing instruction guides Jekyll plugins at site
compile time. The rendered code is displayed in an embellished bordered box with
an (optional) header (usually containing the originating file name and code
region name), as well as an interactive copy-code button.

Nothing extra needs to be added to the processing instructions (other than selected arguments like `title`, when desired). Generation of the adorning HTML is handled by Jekyll plugins like [markdown_with_code_excerpts.rb][].

## Code diffs

To make use of code diffs in a given page, add the following to the page's front matter (or archive the equivalent setting using `_config.yml` file defaults):

```yaml
diff2html: true
```

A `<?code-excerpt?>` instruction will procduce a code diff when two files are named using either of the following methods:

- Use the `diff-with` argument: `diff-with="path/to/second/file.ext"`.
- Use the bash brace syntax in the instruction's first unnamed argument:
  `path/to/{first,second}/file.ext`.

## Site-global and file-scope code excerpt transformations

The [code_excerpt_updater][] tool can apply site-global, file-scope and
code-excerpt specific `replace` transformations.

Site-global transformations are applied to all code excerpts. See
`./tool/refresh-code-excerpts.sh` for an annotated list of replace expressions passed
along with the `--replace` command line argument of the `code_excerpt_updater` command.

File-scope replace instructions can be placed anywhere in a doc page. Most often
the appear at the beginning of the page. Here is an example from
[src/_guides/language/effective-dart/design.md][]:

```html
<?code-excerpt replace="/([A-Z]\w*)\d\b/$1/g"?>
```

This particular transformation strips the trailing version number off of class names. For
example `String0` becomes `String`, and `Point1`, `Point2`, etc. all become `Point`. This
allows the originating source file to contain multiple versions of the same class.


[\<?code-excerpt?> syntax]: https://github.com/chalin/code_excerpt_updater#3-code-excerpt-syntax
[code_excerpt_updater]: https://github.com/chalin/code_excerpt_updater
[code_excerpter]: https://github.com/chalin/code_excerpter
[examples]: examples.md
[hello-world example]: https://github.com/dart-lang/site-www/blob/master/examples/misc/test/samples_test.dart
[layout/lakes/interactive/lib/main.dart]: https://github.com/flutter/website/blob/master/examples/layout/lakes/interactive/lib/main.dart?raw=1
[markdown_with_code_excerpts.rb]: src/_plugins/markdown_with_code_excerpts.rb
[processing instruction]: https://en.wikipedia.org/wiki/Processing_Instruction
[regular expression]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions
[Should I write a test?]: examples#should-i-write-a-test
[src/_guides/language/effective-dart/design.md]: https://github.com/dart-lang/site-www/blob/master/src/_guides/language/effective-dart/design.md?raw=1
[src/docs/development/ui/interactive.md]: https://github.com/flutter/website/blob/master/src/docs/development/ui/interactive.md?raw=1
