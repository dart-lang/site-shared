---
title: Markdown
description: Markdown
---

# Markdown

## Code blocks

There are two ways to document code blocks on our sites:

 1. Use standard markdown syntax for fenced code like this:

        ```dart
        class C { ... }
        ```

 1. Use the [prettify][] Jekyll block tag, supported via a custom plugin
    designed for use on our sites:

    ```
    {% prettify dart %}
    void main() { ... }
    {% endprettify %}
    ```

### **PREFER** using ``` fenced markdown for **code blocks**

Standard markdown syntax is recognized by many IDEs as well as online editors
and viewers like those available on GitHub. These tools offer convenient syntax
highlighting and more. Markdown syntax can be used in site pages as well as API
documentation.

For these reasons, prefer standard markdown code-block syntax over use of the
Jekyll prettify block tag.

Use the `prettify` block tag if you need support for code highlighting, and your
site isn't using the [markdown_with_code_excerpts.rb][] plugin.

## **AVOID** using HTML when markdown syntax will do

Markdown syntax is easier to read and write. Avoid using HTML, such as lists
(`<ul>` or `<ol>`) and tables when markdown syntax will do.

## **DO** properly indent markdown lists

Indentation is part of the markdown syntax. The following indentation
conventions make it easier to work with lists.

For **_unordered lists_**, indent all but the first line by **two spaces** more
than the first line like this (`|` represents the left margin):

    |- First line of bulleted list.
    |  Second line is indented to match.
    |
    |  ```dart
    |  // Some code
    |  ```

Start **_ordered lists_ one space** from the left margin, and indent all content
by **four spaces**:

    | 1. First line of bulleted list.
    |    Second line is indented to match.
    |
    |    ```dart
    |    // Some code
    |    ```

## **PREFER** placing link definitions after the text containing them

Embedding link URLs inside text makes the text difficult to read, for example:

    Now that we have a `TabController` to work with, we can create our
    tabs using the [TabBar](https://docs.flutter.io/flutter/material/TabController-class.html) widget.
    In this example, we'll create a `TabBar` with 3 [Tab](https://docs.flutter.io/flutter/material/Tab-class.html)
    widgets and place it within an [AppBar](https://docs.flutter.io/flutter/material/AppBar-class.html).

Instead, place link definitions after the paragraph, or if it is used more than
once, at the end of the page:

    Now that we have a `TabController` to work with, we can create our
    tabs using the [TabBar][] widget.
    In this example, we'll create a `TabBar` with 3 [Tab][]
    widgets and place it within an [AppBar][].

    [AppBar]: https://docs.flutter.io/flutter/material/AppBar-class.html
    [Tab]: https://docs.flutter.io/flutter/material/Tab-class.html
    [TabBar]: https://docs.flutter.io/flutter/material/TabController-class.html

[markdown_with_code_excerpts.rb]: src/_plugins/markdown_with_code_excerpts.rb
[prettify]: src/_plugins/prettify.rb
