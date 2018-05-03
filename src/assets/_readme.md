## Notes

- Assets in this folder get merged into the assets folder created by jekyll-assets from _assets.
- This folder is only needed until https://github.com/dart-lang/site-www/issues/502 is fixed.

## Files

- `dart-logo-for-shares.png` og_image file, created with a ratio of 1.75, because for anything
  larger, the image was getting clipped width-wise (as reported by the Facebook debugger).
- Icons like `dart/icon/64.png` should be identical to the corresponding icon under `_assets`
  &mdash; `../_assets/images/dart/icon/64.png` in this case.
