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
the markdown processor and [Rouge][] as the default syntax highlighter.

To see a list of the languages you can use with <code>```</code>, see
Rouge's [list of supported languages and lexer][languages].
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

- [jekyll-toc][] for auto-generation of page table of contents.

We share custom plugins across sites. These can be found under [src/_plugins][].
To use a shared plugin, create a symlink from the plugin in
`site-shared/src/_plugins` to the repo's `src/_plugins` folder.

[bundler]: https://bundler.io
[Default configuration]: https://jekyllrb.com/docs/configuration/default/
[git submodule]: https://git-scm.com/book/en/v2/Git-Tools-Submodules
[Jekyll]: https://jekyllrb.com
[jekyll-toc]: https://github.com/toshimaru/jekyll-toc
[languages]: https://github.com/rouge-ruby/rouge/wiki/List-of-supported-languages-and-lexers
[Rouge]: https://github.com/rouge-ruby/rouge
[src/_assets]: https://github.com/dart-lang/site-shared/tree/main/src/_assets
[src/_plugins]: https://github.com/dart-lang/site-shared/tree/main/src/_plugins
[src/_assets/css/_code_pre.scss]: https://github.com/dart-lang/site-shared/tree/main/src/_assets/css/_code_pre.scss
[tool/before-install.sh]: https://github.com/dart-lang/site-shared/tree/main/tool/before-install.sh
