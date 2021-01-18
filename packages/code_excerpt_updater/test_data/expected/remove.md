## Test remove attribute

Test plain string argument:

<?code-excerpt "basic.dart" remove="$greeting"?>
```
var greeting = 'hello';
var scope = 'world';
```

Test regexp argument:

<?code-excerpt "basic.dart" remove="/^v/"?>
```
```

Test plain string of the form `/.../`:

<?code-excerpt "indented_frag.dart (single code block)" remove="\//"?>
```
var x = 1;
return x;
```
