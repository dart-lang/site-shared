# Markdown

The site's Markdown processing uses
[Kramdown's GitHub Flavored Markdown parser][kramdown-gfm],
meaning you can write using [GitHub Flavored Markdown][].

## Code blocks

Use standard markdown syntax for fenced code blocks.

````markdown
```dart
class C { ... }
```
````

## **AVOID** using HTML when markdown syntax will do

Markdown syntax is easier to read and write. Avoid using HTML, such as lists
(`<ul>` or `<ol>`) and tables when markdown syntax will do.

## **DO** properly indent markdown lists

Indentation is part of the markdown syntax. The following indentation
conventions make it easier to work with lists.

For **_unordered lists_**, indent all but the first line by **two spaces** more
than the first line like this (`|` represents the left margin):

````markdown
|- First line of bulleted list.
|  Second line is indented to match.
|
|  ```dart
|  // Some code
|  ```
````

Start **_ordered lists_ one space** from the left margin, and indent all content
by **four spaces**:

```markdown
| 1. First line of bulleted list.
|    Second line is indented to match.
|
|    ```dart
|    // Some code
|    ```
```

## **PREFER** placing link definitions after the text containing them

Embedding link URLs inside text makes the text difficult to read, for example:

```markdown
Now that you have a `TabController` to work with, you can create
tabs using the [TabBar](https://api.flutter.dev/flutter/material/TabBar-class.html) widget.
In this example, you'll create a `TabBar` with 3 [Tab](https://api.flutter.dev/flutter/material/Tab-class.html)
widgets and place it within an [AppBar](https://api.flutter.dev/flutter/material/AppBar-class.html).
```

Instead, place link definitions at the end of the current section, 
or if it is used more than once, at the end of the page:

```markdown
Now that you have a `TabController` to work with, you can create
tabs using the [TabBar][] widget.
In this example, you'll create a `TabBar` with 3 [Tab][]
widgets and place it within an [AppBar][].

[AppBar]: https://api.flutter.dev/flutter/material/AppBar-class.html
[Tab]: https://api.flutter.dev/flutter/material/Tab-class.html
[TabBar]: https://api.flutter.dev/flutter/material/TabBar-class.html
```

## **PREFER** using `**` to emphasize text

Both `**` and `__` are supported for emphasizing text.
Prefer `**` for consistency across the site:

```markdown
On your device, open **Settings**.
```

[kramdown-gfm]: https://github.com/kramdown/parser-gfm
[GitHub Flavored Markdown]: https://github.github.com/gfm/
[markdown_with_code_excerpts.rb]: src/_plugins/markdown_with_code_excerpts.rb
[prettify]: src/_plugins/prettify.rb
