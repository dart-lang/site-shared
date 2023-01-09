## Compressing

Compress/optimize all images uploaded to the site
to reduce site load time as well as Jekyll build time.

TODO: Include tool in site infrastructure for optimizing images

## Centering

Ways to center an image, while allowing it to be responsive:

```
![...](path/file.ext){: .mw-100}
{:.text-center}
```

The previous example must be preceded and followed by a blank line
so that the `text-center` class is applied to the paragraph
that will be wrapping the image.

This one adds padding after the image too:

```html
<div class="text-center mb-4">
  ![...](path/file.ext){: .mw-100}
</div>
```

If you know that your image will fit
within the page as rendered on your smallest target device, 
then you can use the following:

```markdown
![...](path/file.ext){:width="160px" .d-block .mx-auto}
```

## Alt text

If an image is not decorative and not just used as a visual guide,
specify alt text following the [alt text style guide][]. 
This goes in the initial `[]` using Markdown syntax.

```markdown
![AnimatedBuilder widget tree](/path/widget_tree.png)
```

[alt text style guide]: https://developers.google.com/style/images#alt-text
