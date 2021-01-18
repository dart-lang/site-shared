## Test `from` arg

<?code-excerpt "basic.dart" from="world"?>
```dart
var scope = 'world';

void main() => print('$greeting $scope');
```

Pattern not in excerpt:

<?code-excerpt "basic.dart" from="zzz"?>
```dart
```

## Test `to` arg

<?code-excerpt "basic.dart" to="world"?>
```dart
var greeting = 'hello';
var scope = 'world';
```

Pattern matching last line of excerpt:

<?code-excerpt "basic.dart" to="main"?>
```dart
var greeting = 'hello';
var scope = 'world';

void main() => print('$greeting $scope');
```

Pattern not in excerpt:

<?code-excerpt "basic.dart" to="zzz"?>
```dart
var greeting = 'hello';
var scope = 'world';

void main() => print('$greeting $scope');
```

## Test `from` and `to`

<?code-excerpt "basic.dart" from="world" to="world"?>
```dart
var scope = 'world';
```
