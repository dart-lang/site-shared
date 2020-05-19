Ensuring that a page is mobile friendly can take a little more effort than ensuring that images are responsive. Here are some points to consider:

- Responsive **images**. A lot could be written here, including serving size-appropriate images depending on the client). When no other measures are taken, at a minimum, ensure that images are assigned the `mw-100` class.
- **Videos** are a bit trickier to deal with. This is what we've used so far on flutter/website:

  ```html
  <div class="embedded-video-wrapper">
    <iframe class="embedded-video-wrapper__frame"
      src="https://www.youtube.com/embed/CEcFnqRDfgw?rel=0"
      frameborder="0" allowfullscreen>
    </iframe>
  </div>
  ```
- On narrow mobile displays, long words or strings that don't **word-break** (like program identifiers), can cause horizontal page overflow. In these cases consider the following options:

  - Insert `&shy;` in your text, where appropriate, to allow word-breaks and have a hyphen displayed at the break
  - Insert `<wbr>` to indicate a possible word-break point (without having a hyphen displayed)
  - Use CSS: `word-break: break-word;`

  Using the CSS style is simplest, but since you aren't choosing the word-break points, the result isn't
  always aesthetically pleasing, but it has the advantage of allowing you to not alter the text. Inserting
  `&shy;` or `<wbr>` gives nicer results but can throw off text-search/replace.

When checking whether a page is mobile-friendly, Chrome's device emulator is great for the bulk of the work but I've found it necessary to validate on a real device (or an official emulator -- like the iOS simulator). There is a tradeoff to be had: Chrome is easier to use (e.g., for page navigation and search), but official emulators/real devices are the final arbiters.
