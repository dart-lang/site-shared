---
title: Infrastructure
description: Infrastructure
---

# Infrastructure

## Git submodule

Sites making use of `site-shared` include it as a [git submodule][] of the same
name at the site repo's root.

To use a specific `site-shared` resource, you'll generally create a symlink to
the desired resource file. In some cases, you'll needed to adjust the site
`_config.yml`. Details are given below.

## Jekyll

We use the [Jekyll][] site generator, leaving most of its configuration options
at their [default settings][Default configuration], including use of Kramdown as
the markdown processor and Rouge as the default syntax highlighter.

To see a list of the languages you can use with <code>```</code>, go to
https://github.com/rouge-ruby/rouge/wiki/List-of-supported-languages-and-lexers.
The most common languages we use are `dart`, <code>console</code> (or its equivalent,
<code>terminal</code>), <code>nocode</code>, and <code>yaml</code>.

## Ruby gems and the bundler

Jekyll is written in Ruby, so we use the [bundler][] (the equivalent of Dart's
pub) to manage gems (the equivalent of pub packages). Each site's `Gemfile`
specifies the gems it uses, possibly constraining gem versions (similar to what
you'd do using a `pubspec.yaml` file). The bundler creates a `Gemfile.lock`
which (transitively) lists the gems and gem versions actually used for the site.

> **Note:** The bundler gets installed using [tool/before-install.sh][].

For optimal sharing of resources across sites, ensure that the sites' `Gemfile`s
are kept as in sync to the extent practical / possible.

## Jekyll plugins

The main third-party Jekyll plugins we use are the following:

- [jekyll-assets][], for asset management. Assets are the site files under
  `src/_assets`. For production builds, jekyll-assets does asset file
  finger-printing. This ensures that resource file caching won't interfere with
  the release of new asset versions since each asset file is suffixed with a
  hash determined from the file content.
- [jekyll-toc][] for autogeneration of page table of contents.

We share custom plugins across sites. These can be found under [src/_plugins][].
To use a shared plugin, create a symlink from the plugin in
`site-shared/src/_plugins` to the repo's `src/_plugins` folder.

## Assets

You can tell [jekyll-assets][] where to look for shared assets (like CSS and JS
files) by adding the following lines to a site's Jekyll config file
(`_config.yml`):

```yaml
assets:
  sources:
    - _shared/_assets
    - _shared/_assets/css
```

This assumes that you've setup a single symlink to the `site-shared` submodule
by running the following commands (from the repo root):

```console
$ cd src
$ ln -s ../site-shared/src _shared
```

Once this is setup, then you can simply "include" `site-shared` assets like CSS
files (such as [src/_assets/css/_code_pre.scss][]) like this:

```scss
@import '_code_pre';
```

JavaScript can be similarly imported:

```js
//= require vendor/jquery-3.6.0
```

> **Note:** `//= require` is [jekyll-assets][] include syntax.

[bundler]: https://bundler.io
[Default configuration]: https://jekyllrb.com/docs/configuration/default/
[git submodule]: https://git-scm.com/book/en/v2/Git-Tools-Submodules
[Jekyll]: https://jekyllrb.com
[jekyll-assets]: https://github.com/envygeeks/jekyll-assets
[jekyll-toc]: https://github.com/toshimaru/jekyll-toc
[src/_assets]: https://github.com/dart-lang/site-shared/tree/master/src/_assets
[src/_plugins]: https://github.com/dart-lang/site-shared/tree/master/src/_plugins
[src/_assets/css/_code_pre.scss]: https://github.com/dart-lang/site-shared/tree/master/src/_assets/css/_code_pre.scss
[tool/before-install.sh]: https://github.com/dart-lang/site-shared/tree/master/tool/before-install.sh
