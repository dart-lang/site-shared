## Test replace attribute

<?code-excerpt "basic.dart" replace="/hello/bonjour/g"?>
```
```

<?code-excerpt "basic.dart" replace="/hell(o)/b$1nj$1ur$$1$2/g"?>
```
```

<?code-excerpt "basic.dart" replace="/hel*o/$& $&/g"?>
```
```

<?code-excerpt "basic.dart" replace="/hello/$&\/bonjour/g"?>
```
```

<?code-excerpt "basic.dart" replace="/;/; \/\/!/g;/hello/bonjour/g;/(bonjour.*?)!/$1?/g"?>
```
```

### Special characters starting with a slash

- Test `\n` in regexp part

  <?code-excerpt "no_region.html" replace="/\n//g"?>
  ```
  ```

- Test `\n` in replacement part, along with escaped `\\n`:

  <?code-excerpt "quote.md" replace="/\s*\*+\s*/\n/g; /\./\\n/g"?>
  ```
  ```

- Test replacement of `>` when written as `\x3E`:

  <?code-excerpt "no_region.html" replace="/<(\/?)h1\x3E/<$1h2\x3E/g"?>
  ```
  ```

- Ensure that double slashes aren't interpreted specially:

  <?code-excerpt "no_region.html" replace="/\\x3E//g; /!/\\xAB/g"?>
  ```
  ```

### Command-line and File-global replace test

Command-line replace expression is /mundo/$&!/g, which is to be applied last.

<?code-excerpt replace="/bonjour/hola/g"?>

<?code-excerpt "basic.dart" replace="/hello/bonjour/g;/world/mundo/g"?>
```
```

### Reset file-global replace

<?code-excerpt replace=""?>
<?code-excerpt "basic.dart" replace="/hello/bonjour/g"?>
```
```

### Regression: support `}` in regexp.

<?code-excerpt "basic.dart" replace="/([\)\}]);/$1; \/\/!/g"?>
```
```
