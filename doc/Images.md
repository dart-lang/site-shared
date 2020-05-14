## Compressing

Most site have a gulp task that can be used to compress all images, for example:

```terminal
npx gulp compress-images [--path=some/path]
```

## Centering

Ways to center an image, while allowing it to be responsive:

```
{% asset path/file.ext class="mw-100" alt="..." %}
{:.text-center}
```

The previous example must be be preceded and followed by a blank line so that the `text-center` class is applied to the paragraph that will be wrapping the image.

This one adds padding after the image too:

```html
<div class="text-center mb-4">
  {% asset path/file.ext class="mw-100" alt="..." %}
</div>
```

If you know that your image will fit within the page as rendered on your smallest target device, then you can use the following:

```
{% asset path/file.ext class="d-block mx-auto" width="160px" ... %}
```

```markdown
![AnimatedBuilder widget tree][]{:.mx-auto.d-block}

[AnimatedBuilder widget tree]: {% asset path/file.ext @path %}
```
