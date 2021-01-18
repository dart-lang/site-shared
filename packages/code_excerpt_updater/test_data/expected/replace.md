## Test replace attribute

<?code-excerpt "basic.dart" replace="/hello/bonjour/g"?>
```
var greeting = 'bonjour';
var scope = 'world';

void main() => print('$greeting $scope');
```

<?code-excerpt "basic.dart" replace="/hell(o)/b$1nj$1ur$$1$2/g"?>
```
var greeting = 'bonjour$1$2';
var scope = 'world';

void main() => print('$greeting $scope');
```

<?code-excerpt "basic.dart" replace="/hel*o/$& $&/g"?>
```
var greeting = 'hello hello';
var scope = 'world';

void main() => print('$greeting $scope');
```

<?code-excerpt "basic.dart" replace="/hello/$&\/bonjour/g"?>
```
var greeting = 'hello/bonjour';
var scope = 'world';

void main() => print('$greeting $scope');
```

<?code-excerpt "basic.dart" replace="/;/; \/\/!/g;/hello/bonjour/g;/(bonjour.*?)!/$1?/g"?>
```
var greeting = 'bonjour'; //?
var scope = 'world'; //!

void main() => print('$greeting $scope'); //!
```

### Special characters starting with a slash

- Test `\n` in regexp part

  <?code-excerpt "no_region.html" replace="/\n//g"?>
  ```
  <div>  <h1>Hello World!</h1></div>
  ```

- Test `\n` in replacement part, along with escaped `\\n`:

  <?code-excerpt "quote.md" replace="/\s*\*+\s*/\n/g; /\./\\n/g"?>
  ```
  This is a
  markdown
  fragment\n
  ```

- Test replacement of `>` when written as `\x3E`:

  <?code-excerpt "no_region.html" replace="/<(\/?)h1\x3E/<$1h2\x3E/g"?>
  ```
  <div>
    <h2>Hello World!</h2>
  </div>
  ```

- Ensure that double slashes aren't interpreted specially:

  <?code-excerpt "no_region.html" replace="/\\x3E//g; /!/\\xAB/g"?>
  ```
  <div>
    <h1>Hello World\xAB</h1>
  </div>
  ```

### Command-line and File-global replace test

Command-line replace expression is /mundo/$&!/g, which is to be applied last.

<?code-excerpt replace="/bonjour/hola/g"?>

<?code-excerpt "basic.dart" replace="/hello/bonjour/g;/world/mundo/g"?>
```
var greeting = 'hola';
var scope = 'mundo!';

void main() => print('$greeting $scope');
```

### Reset file-global replace

<?code-excerpt replace=""?>
<?code-excerpt "basic.dart" replace="/hello/bonjour/g"?>
```
var greeting = 'bonjour';
var scope = 'world';

void main() => print('$greeting $scope');
```

### Regression: support `}` in regexp.

<?code-excerpt "basic.dart" replace="/([\)\}]);/$1; \/\/!/g"?>
```
var greeting = 'hello';
var scope = 'world';

void main() => print('$greeting $scope'); //!
```
