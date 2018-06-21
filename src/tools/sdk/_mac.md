[Install homebrew](http://brew.sh/), and then run:

```terminal
$ brew tap dart-lang/dart
$ brew install dart
```

To install a **dev channel** release use `--devel`:

```terminal
$ brew install dart --devel
```

### Upgrade

To upgrade when a new release of Dart is available run:

```terminal
$ brew upgrade dart
```

To upgrade to a dev channel release when a stable release is currently active run:

```terminal
$ brew upgrade dart --devel --force
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

The command output includes the latest stable and dev versions at the top, and
your locally installed versions are listed after that.
