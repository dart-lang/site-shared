## Test retain attribute

Test plain string argument:

<?code-excerpt "basic.dart" retain="$greeting"?>
```
void main() => print('$greeting $scope');
```

Test regexp argument:

<?code-excerpt "basic.dart" retain="/^v/"?>
```
var greeting = 'hello';
var scope = 'world';
void main() => print('$greeting $scope');
```

Test plain string of the form `/.../`:

<?code-excerpt "indented_frag.dart (single code block)" retain="\//"?>
```
// Fragment is indented by 4 spaces
```
