## Test plaster feature

Testing of this feature only became relevant with the use of YAML excerpts.

### Plaster for language without comment syntax

<?code-excerpt "plaster.txt"?>
```
abc
···
def
```

### Plaster for language with comment syntax

Languages with start-comment syntax:

<?code-excerpt "plaster.dart"?>
```
var greeting = 'hello';
// ···
var scope = 'world';
```

Languages with start- and end-comment syntax:

<?code-excerpt "plaster.css"?>
```
.abc {}
/* ··· */
.def {}
```

<?code-excerpt "plaster.html"?>
```
<p>
<!-- ··· -->
</p>
```

<?code-excerpt "plaster.yaml"?>
```
abc:
  # ···
  def
```

### Remove plaster

<?code-excerpt "plaster.txt" plaster="none"?>
```
abc
def
```

<?code-excerpt "plaster.dart" plaster="none"?>
```
var greeting = 'hello';
var scope = 'world';
```

<?code-excerpt "plaster.yaml" plaster="none"?>
```
abc:
  def
```

### Language spec on code block

<?code-excerpt "plaster.dart (html)"?>
```html
<p>
<!-- ··· -->
</p>
```

<?code-excerpt "plaster.dart (html)"?>
{% prettify html %}
<p>
<!-- ··· -->
</p>
{% endprettify %}

### Custom template

<?code-excerpt "plaster.dart" plaster="/*...*/"?>
```
var greeting = 'hello';
/*...*/
var scope = 'world';
```

<?code-excerpt "plaster.dart" plaster="/* $defaultPlaster */"?>
```
var greeting = 'hello';
/* ··· */
var scope = 'world';
```
