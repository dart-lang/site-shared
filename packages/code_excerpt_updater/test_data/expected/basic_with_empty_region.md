Test: empty region

<?code-excerpt "basic.dart (greeting)" title?>
```dart
var greeting = 'hello';
var scope = 'world';
```

The full file, because an empty region overrides the parenthecial remark in the path/title:
<?code-excerpt "basic.dart (greeting)" region="" title?>
```dart
var greeting = 'hello';
var scope = 'world';

void main() => print('$greeting $scope');
```
