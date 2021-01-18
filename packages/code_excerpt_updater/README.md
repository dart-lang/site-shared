# Markdown code-block updater

This is the repo for a simple _line-based_ updater for markdown code-blocks preceded by XML
processor instructions of the form `<?code-excerpt ...?>`. Dart (`.dart`), markdown (`.md`), and 
Jade (`.jade`) files are processed. For Dart source files, code blocks in API comments are updated.

## 1. Installation

```shell
pub global activate --source git https://github.com/chalin/code_excerpt_updater.git
```

## 2. Usage

```
Usage: code_excerpt_updater [OPTIONS] file_or_directory...

    --exclude=<PATH_REGEXP,...>       Paths to exclude when processing a directory recursively.
                                      Dot files and directorys are always excluded.

    --fail-on-refresh                 Report a non-zero exit code if a fragment is refreshed.
-p, --fragment-dir-path               PATH to directory containing code fragment files
                                      (defaults to "", that is, the current working directory).

-h, --help                            Show command help.
-i, --indentation                     NUMBER. Default number of spaces to use as indentation for code inside code blocks.
                                      (defaults to "0")

-q, --src-dir-path                    PATH to directory containing code used in diffs
                                      (defaults to "", that is, the current working directory).

-w, --write-in-place                  Write updates to files in-place.
    --[no-]escape-ng-interpolation    Escape Angular interpolation syntax {{...}} as {!{...}!}.
                                      (defaults to on)

    --plaster                         TEMPLATE. Default plaster template to use for all files.
                                      For example, "// Insert your code here"; use "none" to remove plasters.

    --replace                         REPLACE-EXPRESSIONs. Global replace argument. See README for syntax.
    --yaml                            Read excerpts from *.excerpt.yaml files.
```

Returns a non-zero exit code errors occur during file processing, or if fragments were refreshed and 
`--fail-on-refresh` is requested.

## 3. `<?code-excerpt?>` syntax

### a. Code fragment

The instruction comes in three forms. The first (and most common) form must immediately precede a markdown code block:


    <?code-excerpt "path/file.ext (optional-region-name)" arg0="value0" ...?>
    ```
      ...
    ```

The first (unnamed) argument defines a path to a fragment file. The argument can optionally name a code fragment region
&mdash; any non-word character sequences (`\w+`) in the region name are converted to a hyphen.

Recognized arguments are:

- `from="string|/regex/"`: skips the initial lines until one is found matching the given pattern.
- `region`, a code fragment region name.
- `replace="/regexp/replacement/g;..."` defines one or more semi-colon separated [regular expression][]/replacement
  expression pairs for use in a global search-and-replace applied to the code excerpt.
  The replacement expression can contain capture group syntax `$&`, `$1`, `$2`, ... .
- `remove="string|/regexp/"`: remove the lines, from the identified code excerpt file, which contain the given string
   or match _regexp_. To match a string starting with a slash, escape it.
- `retain="string|/regexp/"`: retain the lines, from the identified code excerpt file, which contain the given string
   or match _regexp_. To match a string starting with a slash, escape it.
- `indent-by` defines the number of spaces to be used to indent the code in the code block.
   (Default is no indentation.)
- `path-base`, when provided, must be the only argument. Its use is described below in the second instruction form.
- `plaster="..."` determines how plaster marker lines are handled in excerpts. When set to "none", the plaster marker
  lines are removed. Otherwise, the attribute value defines a plaster template, possibly containing `$defaultPlaster`.
  Examples: `plaster="/* $defaultPlaster */"`, `plaster="/* add your code here */"`.
  When using legacy excerpts, the only supported value of this attribute is "none".
  The default plaster is `···`, contained in a language-specific comment that is determined from the excerpt directive.
  The language is the code-block language, if specified, otherwise it is taken to be the excerpt path extension.
- `skip="n"`: skips the first _n_ lines of the excerpt when _n_ is non-negative; drops (skips) the last
  _n_ lines otherwise.
- `take="n"`: takes the first _n_ lines of the excerpt when _n_ is non-negative; takes the last
  _n_ lines otherwise.
- `to="string|/regex/"`: skips the lines after the first line found matching the given pattern.

Notes:
- Arguments are processed in the order they appear. This is significant for arguments like
  `replace`, `remove`, etc.
- The `<?code-excerpt?>` instruction can optionally be preceded by an single-line comment
  token. Namely either `//` or `///`.
- Path, and arguments if given, must be enclosed in double quotes.
- It is a limitation of processing instructions that it cannot contain a `>` character.
  This limitation can be overcome in some situations: e.g., in a regexp, use `\x3E` as an encoding of `>`.
- If both `retain` and `replace` arguments are provided, the `retain` filter is always applied first.

### b. Code diff

The second form of the instruction must also be followed by a code block:

    <?code-excerpt "path/file1.ext (optional-region-name)" diff-with="path2/file2.ext2" optional-args?>
    ```
      ...
    ```

If you diff files whose paths share a prefix and/or suffix, then you can drop the
`diff-with` argument and use the Bash path-brace syntax instead. For example:

    <?code-excerpt "path/{subpath1,subpath2}/file.ext (optional-region-name)" optional-args?>
    ```
      ...
    ```

These are the optional arguments (usage is explained further below):

- `from="regexp"`
- `to="regexp"`
- `diff-u="NUM"`

When the code_excerpt_updater is run, it will update the content of the code
block with the output of `diff -u path/filtered_file1.ext path2/filtered_file2.ext2` truncated at the first diff 
output line that matches the `to` regular expression, where the `filtered_file*.ext*` represents the corresponding
file `file*.ext*` but with docregion tags removed. When an optional region name is provided, then the named regions
(the same in both files) are compared.

If `diff-u="NUM"` is used, then the diff command is called with the `-U NUM` flag instead of `-u`.

### c. Set instruction

Use a set instruction to globally set a path base, or a replace expression (using the syntax described above).

A global **replace** instructions applies to all subsequence code-excerpt instructions. To reset, use an
empty replace argument. If a code-excerpt instruction has a replace argument, the global replace
is applied after the code-excerpt-specific replace.

Here is an example of setting a **path base**:

```
<?code-excerpt path-base="subdirPath"?>
```

Following this instruction, the paths to file fragments will be interpreted relative to the `path-base` argument.

### Limitations

XML processing instructions cannot contain `>`. In particular this means that attribute values cannot contain `>`,
which is a limitation for the diff `from` and `to` regular expressions.

## 4. Code excerpt lookup and updating

The updater does not create code fragment files. It does expect such files to 
exist and be named following the conventions described below.

For a directive like `<?code-excerpt "dir/file.ext" region="rname"?>`, the updater will search the
fragment folder, for a file named:

- `dir/file-rname.ext.txt`<br>
   or
- `dir/file.ext.txt`<br>
   if the region is omitted

If no such fragment is found, it will search the source directory (`--src-dir-path`) for a file named:

- `dir/file.ext`

If the updater finds a (fragment or original source) file, it will replace the lines contained within
the markdown code block with those from that file, indenting each
fragment file line as specified by the `indent-by` argument.

For example, if `hello.dart.txt` contains the line "print('Hi');" then

```
/// <?code-excerpt "hello.dart" indent-by="2"?>
/// ```dart
///   print('Bonjour');
/// ```
```

will be updated to

```
/// <?code-excerpt "hello.dart" indent-by="2"?>
/// ```dart
///   print('Hi');
/// ```
```

## 5. Example

Consider the following API doc excerpt from the
[NgStyle](https://webdev.dartlang.org/api/angular/angular.common/NgStyle-class) class.

```dart
    /// ### Examples
    ///
    /// Try the [live example][ex] from the [Template Syntax][guide] page. Here are
    /// the relevant excerpts from the example's template and the corresponding
    /// component class:
    ///
    /// <?code-excerpt "docs/template-syntax/lib/app_component.html" region="NgStyle"?>
    /// ```html
    /// ```
    ///
    /// <?code-excerpt "docs/template-syntax/lib/app_component.dart" region="NgStyle"?>
    /// ```dart
    /// ```
```

Given an appropriate path to the folder containing code fragment files, this
update tool would generate:

```dart
    /// ### Examples
    ///
    /// Try the [live example][ex] from the [Template Syntax][guide] page. Here are
    /// the relevant excerpts from the example's template and the corresponding
    /// component class:
    ///
    /// <?code-excerpt "docs/template-syntax/lib/app_component.html" region="NgStyle"?>
    /// ```html
    /// <div>
    ///   <p [ngStyle]="setStyle()" #styleP>Change style of this text!</p>
    /// 
    ///   <label>Italic: <input type="checkbox" [(ngModel)]="isItalic"></label> |
    ///   <label>Bold: <input type="checkbox" [(ngModel)]="isBold"></label> |
    ///   <label>Size: <input type="text" [(ngModel)]="fontSize"></label>
    /// 
    ///   <p>Style set to: <code>'{{styleP.style.cssText}}'</code></p>
    /// </div>
    /// ```
    ///
    /// <?code-excerpt "docs/template-syntax/lib/app_component.dart" region="NgStyle"?>
    /// ```dart
    /// bool isItalic = false;
    /// bool isBold = false;
    /// String fontSize = 'large';
    /// String fontSizePx = '14';
    /// 
    /// Map<String, String> setStyle() {
    ///   return {
    ///     'font-style': isItalic ? 'italic' : 'normal',
    ///     'font-weight': isBold ? 'bold' : 'normal',
    ///     'font-size': fontSize
    ///   };
    /// }
    /// ```
```

## 6. Tests

Repo tests can be launched from `test/main.dart`.

[regular expression]: https://api.dartlang.org/stable/dart-core/RegExp-class.html
