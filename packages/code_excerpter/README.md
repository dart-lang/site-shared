# code_excerpter

A line-based builder for extracting code regions from source files.

Documentation for a package or framework often contains code excerpts.
There are two main approaches to ensuring that such **code excerpts remain
up-to-date** as the package or framework code base evolves.
(1) A [literate programming][] approach, where **code
fragments are extracted from the docs**, then analyzed and tested.
(2) A complementary approach where named **code regions are extracted from
sources**, and docs are refreshed (as needed) when code regions change.

Both approaches have their merits, but `code_excerpter`, and its companion tool 
[code_excerpt_updater][], support (2). More specifically:

- `code_excerpter` is a builder that can be used to extract code regions from source files.
- [code_excerpt_updater][] can be used to refresh code regions inside docs using
  the output from `code_excerpter`

## Usage synopsis

1. One-time setup: define a builder config file.
2. Markup your sources with (optionally named) code regions
   delimited by `#docregion` / `#enddocregion` pairs, each written
   inside a line comment. An example is given below.
3. Run the builder.
4. Use [code_excerpt_updater][] to update your docs.

Repeat steps 2-4 as the code base evolves.

## Examples sources


```dart
// #docregion imports
import 'dart:async';
// #enddocregion imports

// #docregion main, main-stub
void main() async {
  // #enddocregion main-stub
  print('Compute π using the Monte Carlo method.');
  await for (var estimate in computePi().take(500)) {
    print('π ≅ $estimate');
  }
  // #docregion main-stub
}
// #enddocregion main, main-stub

/// Generates a stream of increasingly accurate estimates of π.
Stream<double> computePi({int batch: 100000}) async* {
  // ...
}
```

The regions defined in the Dart source above are: `imports`, `main`, `main-stub`,
and (implicitly) the **default region** named  `''`.
If you don't explicitly delimit the default region, it is assumed to be the
entire file.

Some of the regions defined in the example above include:

- `imports` region:
  > ```dart
  > import 'dart:async';
  > ```

- `main-stub` region:
  > ```dart
  > void main() async {
  >   // ···
  > }
  > ```

The `main-stub` region is discontinuous, that is, it has a break in it.
By default, when the [code_excerpt_updater][] renders a region with breaks,
each breaks is replaced by a (language-specific) comment line filled with a
plaster marker (`···`).

For details concerning the processing of plasters, see the 
[code_excerpt_updater][] documentation.

Notes:

- If a code region end coincides with the file end, then its closing
  `#enddocregion` can be omitted.
- The `code_excerpter` supports source files in all popular languages including
  Dart, HTML, YAML, CSS, SCSS, and more.
  

## Syntax

As illustrated above, the region markers can be followed by zero or more comma-separated region names.

A legal **region name** is one of:

- `''`
- A non-empty sequence of alpha-numeric characters possibly containing a hypen (`-`)
  or an underscore (`_`).

## Sample builder config

To use the builder, create a config file such as the following:

```yaml
targets:
  $default:
    sources:
      include: [examples/**]
      exclude:
        - '**/.*/**'
        - '**/build/**'
    builders:
      code_excerpter|code_excerpter:
        enabled: true
```

Build by running this command:

```console
> pub run build_runner build --output=<some-directory>
```

Yaml files containing excerpts (`*.excerpt.yaml`) will be placed in the build output folder.

[code_excerpt_updater]: https://github.com/chalin/code_excerpt_updater
[literate programming]: https://en.wikipedia.org/wiki/Literate_programming