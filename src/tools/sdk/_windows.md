Choose one of these options:

* [Install using a setup wizard](#install-using-a-setup-wizard)
* [Install using Chocolatey](#install-using-chocolatey)

#### Install using a setup wizard

A [Dart SDK installer for Windows][]{: target="_blank"} is available and
supported by the community. You can use the wizard to install **stable** or
**dev** versions of the Dart SDK.

![Windows Dart Setup Wizard][Windows installer img]{:.text-center width="250"}

#### Install using Chocolatey

Alternatively, you can install using [Chocolatey][].
To install a stable release, run this command:

```terminal
C:\> choco install dart-sdk
```

To install a **dev** release, run this command:

```terminal
C:\> choco install dart-sdk --pre
```

To **upgrade** the Dart SDK, run this command
(add `--pre` to upgrade the dev release):

```terminal
C:\> choco upgrade dart-sdk
```

[Chocolatey]: https://chocolatey.org
[Dart SDK installer for Windows]: http://www.gekorm.com/dart-windows
[Windows installer img]: {% asset_path 'installer-screenshot-no.png' %}
