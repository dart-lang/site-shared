This page has information and links that might come in handy as you develop content for Dart and Flutter websites.

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
  For example, the [site-www `_config.yml` file](https://github.com/dart-lang/site-www/blob/master/_config.yml) defines variables like
  `webdev`, `flutter`, and `dart_api`, so site-www has URLs like
  the following:
  * `{{site.webdev}}`
  * `{{site.webdev}}/tools/dart2js`
  * `{{site.flutter}}/debugging/#the-dart-analyzer`
  * `{{site.dart_api}}/dev`
  * `{{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html`

* Simplify API URLs as much as possible. In particular,
  **do not embed the version** (unless you really want that).
  Consider omitting URL pieces that the server doesn't require.
  For example, don't link to
  [https://api.dart.dev/stable/2.6.0/dart-core/Object-class.html](https://api.dart.dev/stable/2.6.0/dart-core/Object-class.html).
  Instead, change the version string to either **stable** or **dev**
  (or use `{{site.data.pkg-vers.SDK.channel}})`:
  * [{{site.dart_api}}/stable/dart-core/Object-class.html](https://api.dart.dev/stable/dart-core/Object-class.html)
  * [{{site.dart_api}}/dev/dart-core/Object-class.html](https://api.dart.dev/dev/dart-core/Object-class.html)
  * [{{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Object-class.html](https://api.dart.dev/stable/dart-core/Object-class.html)

Also see: https://github.com/dart-lang/site-www/wiki/Referring-to-API-docs

## Images

Use zopfli to compress PNGs.

`brew install zopfli`

Then run it as described in https://ariya.io/2016/06/using-zopfli-to-optimize-png-images.

[TODO: move this section to a new page that talks more about images, assets, etc.]

## Code

Keep code valid and foolproof. People love to copy-paste code.

* Avoid giving bad examples, whenever possible.
* If you need to give bad examples,
  make it impossible to mistake them for good ones.
  (See [Effective Dart: Usage](https://dart.dev/guides/language/effective-dart/usage) for a nice scheme.)

[TODO: move this section to a new page that talks about how we auto-include code?]


## Markdown and HTML

* You can use ordinary Markdown (or HTML, if necessary) on the Dart and Flutter sites. To test your markdown, you can either build the site or paste the code into Markdown previewer such as https://dart-lang.github.io/markdown/.

* If you're using HTML and want italics, use `<em>`. <br>
  The i-tag is used for icon fonts, such as font-awesome.


## Top matter (YAML)

At the top of every page is a bunch of YAML.

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

The **title:** tag is used for the title displayed on the page and (if no **short-title** tag is present)
in the tab.

The **description:** tag replaces the default sharing text
(what you see on Twitter, Facebook, G+).

Add an **image:** tag to replace the default sharing image. For example:

```
image: 'https://dart.dev/path/to/sharing/image.png'
```

[TODO: Check what the path should be. Changes made in [dart-lang/site-webdev#799](https://github.com/dart-lang/site-webdev/pull/799) use a relative path. site-www doesn't have any page-specific images, but [#319](https://github.com/dart-lang/site-www/pull/319) is the corresponding PR.]

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

You'll see `<aside>` used on some older pages for colored boxes:
notes, tips, warnings, and so on.
That's old. Here's the new way to create these boxes:

```
{{site.alert.tip}}
  Tip text goes here.
{{site.alert.end}}
...
{{site.alert.important}}
  Important text goes here.
{{site.alert.end}}
```

You can see the full list of aside/alert types
in your site repo's `_config.yml` file.
For example, search for `alert:` in
[Flutter's `_config.yml` file](https://github.com/flutter/website/blob/master/_config.yml).