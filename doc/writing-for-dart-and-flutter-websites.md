This page has information and links that might come in handy
as you develop content for Dart and Flutter websites.

Contents of this page:
* [Semantic line breaks (<=80 chars)](#semantic-line-breaks)
* [URLs](#urls)
* [Images](#images)
* [Code](#code)
* [Markdown and HTML](#markdown-and-html)
* [Top matter (YAML)](#top-matter-yaml)
* [Asides (notes, tips, warnings, ...)](#asides)

Other resources:

* [Google Developer Documentation Style Guide](https://developers.google.com/style/)
* READMEs for individual sites' repos


## Semantic line breaks

To make revisions and diff review easier, follow these rules:

* Have **<= 80 characters per line.**
  (Some long URLs make that impossible... but try.)
* Break lines at sentences and (unless the sentence is very short)
  on **phrases within sentences.**
* Make sure it's obvious when
  a sentence continues on another line.
  For example, consider adding a word at the end of the first line instead of at
  the beginning of the second line.
  That way future editors and reviewers are
  more likely to notice that
  another line might be affected by the edit.

For example, we might have used this code for the
second sentence of the last bullet above:

```
  For example, consider adding a word at the end of the first line
  instead of at the beginning of the second line.
```

Instead we used this, to make it clear that
a clarifying phrase follows the first line:

```
  For example, consider adding a word at the end of the first line instead of at
  the beginning of the second line.
```

If we subsequently shorten a phrase, it still stays on its own line, even
if the resulting sentence is <= 80 characters.
Fewer diffs!

```
  Maybe put a word on the first line instead of
  the beginning of the second line.
```

More info on semantic line breaks:
* https://rhodesmill.org/brandon/2012/one-sentence-per-line/
* https://sembr.org/


## URLs

Follow these rules when creating links:

* Don't put "/" or ".html" at the end of URLs that link to pages on a
  site-shared site. Examples:
  * **Use `/guides/get-started`**
    _(not `/guides/get-started.html` or `/guides/get-started/` or
    `https://dart.dev/guides/get-started.html`)._
  * **Use `/guides`**_(not `/guides/` or `/guides/index.html` or
    `https://dart.dev/guides/`)._

* If you're editing an `index.html` or `index.md` page,
  don't use relative links. Instead, use links that **start** with `/`.
  Otherwise (because we omit trailing `/`s) links go one directory too high.
  For example, a `/tools` page should link to `/tools/sdk`, not to `sdk`.

* Use jekyll variables if they exist; define new ones if necessary.
  You can find sitewide variables in `/_config.yml`.
  For example, the [site-www `_config.yml` file][] defines variables like
  `dartpad`, `flutter`, and `dart_api`, so site-www has URLs like
  the following:
  * `{{site.dartpad}}`
  * `{{site.flutter}}`
  * `{{site.flutter-docs}}/debugging/#the-dart-analyzer`
  * `{{site.dart-api}}/dev`
  * `{{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html`

  [site-www `_config.yml` file]: https://github.com/dart-lang/site-www/blob/main/_config.yml

* Simplify API URLs as much as possible. In particular,
  **do not embed the version** (unless you really want that).
  Consider omitting URL pieces that the server doesn't require.
  For example, don't link to
  [https://api.dart.dev/stable/2.6.0/dart-core/Object-class.html](https://api.dart.dev/stable/2.6.0/dart-core/Object-class.html).
  Instead, change the version string to either **stable** or **dev**
  (or use `{{site.data.pkg-vers.SDK.channel}})`:
  * [{{site.dart-api}}/stable/dart-core/Object-class.html](https://api.dart.dev/stable/dart-core/Object-class.html)
  * [{{site.dart-api}}/dev/dart-core/Object-class.html](https://api.dart.dev/dev/dart-core/Object-class.html)
  * [{{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Object-class.html](https://api.dart.dev/stable/dart-core/Object-class.html)

Also see: https://github.com/dart-lang/site-www/wiki/Referring-to-API-docs

## Code

Keep code valid and foolproof. People love to copy-paste code.

* Avoid giving bad examples, whenever possible.
* If you need to give bad examples,
  make it impossible to mistake them for good ones.
  (See [Effective Dart: Usage](https://dart.dev/guides/language/effective-dart/usage) for a nice scheme.)
* Use [Code excerpts](https://github.com/dart-lang/site-shared/blob/main/doc/code-excerpts.md)
  to allow analyzing and testing your code
  to make sure it stays up to date.


## Markdown and HTML

* You can use ordinary Markdown (or HTML, if necessary) 
  on the Dart and Flutter sites. 
  To test your markdown, 
  you can either build the site or paste the code into a Markdown previewer
  such as https://dart-lang.github.io/markdown/.

* If you're using HTML and want italics, use `<em>`. <br>
  The i-tag is used for icon fonts, such as font-awesome.

* If you need to include Markdown within HTML,
  add `markdown="1"` to the HTML element.

For more guidelines to follow when writing Markdown,
see our [Markdown guidelines][].

[Markdown guidelines]: https://github.com/dart-lang/site-shared/blob/main/doc/markdown.md

## Liquid templates

The sites support the 
[Liquid template engine][liquid]
for processing templates.
This support is responsible for variable support such as ``{{site.dart-api}}``,
[includes][], custom-built tags, and [filters][].

You can use this support to generate content, include files,
avoid repetition, and more.
To learn more, see the [Liquid documentation][liquid].

If you need to use Liquid syntax in text or a code snippet,
such as when referencing localization resource bundles,
use the [`raw` and `endraw`][raw] tags
to disable tag processing:

````markdown
{% raw %}
```json
{count, plural, =0{no wombats} =1{1 wombat} other{{count} wombats}}
```
{% endraw %}
````

While using Liquid templating functionality to generate content,
also keep in mind [Whitespace control][]
to allow for proper formatting of the generate HTML.

[liquid]: https://shopify.github.io/liquid/
[includes]: https://jekyllrb.com/docs/liquid/tags/#includes
[filters]: https://jekyllrb.com/docs/liquid/filters
[raw]: https://shopify.github.io/liquid/tags/template/#raw
[Whitespace control]: https://shopify.github.io/liquid/basics/whitespace/

## Top matter (YAML)

At the top of every page is a bunch of YAML.
Every published page **must**
have at least a **title** and **description**.

Here's a typical example:

```
---
title: Tools
description: The tools that support the Dart language.
---
```

Here's a bigger example:

```
---
title: Dart SDK Archive
short-title: Archive
description: Download specific stable and dev channel versions of the Dart SDK and the Dart API documentation.
js:
- url: /tools/sdk/archive/out/web/download_archive.dart.js
  defer: true
- url: /tools/sdk/archive/assets/install.js
  defer: true
---
```

The **title:** tag is used for the title displayed on the page 
and (if no **short-title** tag is present) in the tab.
Titles should use sentence case.

The **description:** tag replaces the default sharing text
(what you see on Twitter, Facebook, and other social media).
Descriptions can't have line breaks (`<br`).

Add an **image:** tag to replace the default sharing image. For example:

```
image: 'https://dart.dev/path/to/sharing/image.png'
```


Use **toc: false** to remove a TOC from a page that would ordinarily have one.
Use the value **true** to do the opposite.

You might see a **permalink:** tag; it's used only for dart-lang sites, not for flutter.
On dart-lang/site-*, specifying **permalink:** may be required for index files and
for files that aren't in collections (such as articles, tutorials, codelabs, and guides).

If a file contains obsolete content, but we aren't ready to remove
it entirely, watermark the page using **obsolete: true**.

Other YAML fields are used by specific collections, such
as **nextpage:**, **prevpage:**, **written:**, **updated:**,
and **category**.

## Asides

To add notes, tips, warnings, and other asides
use the following custom-defined Liquid tags:

```
{{site.alert.tip}}
  Tip text goes here.
{{site.alert.end}}
...
{{site.alert.important}}
  Important text goes here.
{{site.alert.end}}
```

All text should within an aside should be consistently indented 2 spaces.

You can see the full list of aside/alert types
in your site repo's `_config.yml` file.
For example, search for `alert:` in
[Flutter's `_config.yml` file](https://github.com/flutter/website/blob/main/_config.yml).
