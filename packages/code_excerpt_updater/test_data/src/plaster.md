## Test plaster feature

Testing of this feature only became relevant with the use of YAML excerpts.

### Plaster for language without comment syntax

<?code-excerpt "plaster.txt"?>
```
```

### Plaster for language with comment syntax

Languages with start-comment syntax:

<?code-excerpt "plaster.dart"?>
```
```

Languages with start- and end-comment syntax:

<?code-excerpt "plaster.css"?>
```
```

<?code-excerpt "plaster.html"?>
```
```

<?code-excerpt "plaster.yaml"?>
```
```

### Remove plaster

<?code-excerpt "plaster.txt" plaster="none"?>
```
```

<?code-excerpt "plaster.dart" plaster="none"?>
```
```

<?code-excerpt "plaster.yaml" plaster="none"?>
```
```

### Language spec on code block

<?code-excerpt "plaster.dart (html)"?>
```html
```

<?code-excerpt "plaster.dart (html)"?>
{% prettify html %}
{% endprettify %}

### Custom template

<?code-excerpt "plaster.dart" plaster="/*...*/"?>
```
```

<?code-excerpt "plaster.dart" plaster="/* $defaultPlaster */"?>
```
```
