## Setup

```console
> brew install imagemagick --with-rsvg
```

## Icons

These are some of the commands used to generate icons:

```console
> cd src/_assets/images
> convert -size 64x64 -background transparent -quality 95 angular/icon/{200.svg,64.png}
> convert -resize 64x64 -quality 95 flutter/icon/{1080,64}.png
> convert -size 64x64 -background transparent -quality 95 dart/icon/{default.svg,64.png}
```

## Favicon.ico

Some consider this PNG packaging format obsolete, given that we can now identify
individual PNGs and their corresponding sizes via `<link>` elements.

But, if you do need to generate one, use this command:

```console
> convert dart/logo/1080px.png -define icon:auto-resize=128,64,48,32,16 dart/favicon.ico
```
