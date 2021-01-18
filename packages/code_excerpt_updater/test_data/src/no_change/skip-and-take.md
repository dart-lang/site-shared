## Test `skip`

<?code-excerpt "basic.dart" skip="3"?>
```dart
void main() => print('$greeting $scope');
```

Negative arg:

<?code-excerpt "basic.dart" skip="-2"?>
```dart
var greeting = 'hello';
var scope = 'world';
```

## Test `take`

<?code-excerpt "basic.dart" take="2"?>
```dart
var greeting = 'hello';
var scope = 'world';
```

Negative arg:

<?code-excerpt "basic.dart" take="-1"?>
```dart
void main() => print('$greeting $scope');
```

## Test `skip` and `take` together

<?code-excerpt "basic.dart" take="+2" skip="1"?>
```dart
var scope = 'world';
```
