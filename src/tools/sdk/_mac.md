[Install homebrew](http://brew.sh/), and then run:

{% if site.data.pkg-vers.SDK.channel == 'dev' %}
```terminal
$ brew tap dart-lang/dart
$ brew install dart --devel
```

To install a **stable channel** release,
don't use `--devel`:

```terminal
$ brew install dart
```

{% else %}
```terminal
$ brew tap dart-lang/dart
$ brew install dart
```

To install a **dev channel** release, use `--devel`:

```terminal
$ brew install dart --devel
```
{% endif %}


### Upgrade

To upgrade when a new release of Dart is available run:

```terminal
$ brew upgrade dart
```

To upgrade to a dev channel release when a stable release is
currently active, run:

```terminal
$ brew upgrade dart --devel --force
```

To install the most recent stable channel release when
a more recent dev release is currently active, run:

```terminal
$ brew uninstall dart
$ brew install dart
```

### Switch release

To switch between locally installed dart releases run
`brew switch dart <version>`. Examples:

```terminal
$ brew switch dart 1.24.3
$ brew switch dart 2.0.0-dev.64.1
```

If you aren't sure which versions of dart you have installed, then run:

```terminal
$ brew info dart
```

The command output lists the latest stable and dev versions at the top,
followed by your locally installed versions.
