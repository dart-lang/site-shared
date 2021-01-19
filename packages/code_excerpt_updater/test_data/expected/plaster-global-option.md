## Test plaster feature

### Globally set default plaster

<?code-excerpt "plaster.dart"?>
```
var greeting = 'hello';
// Insert your code here ···
var scope = 'world';
```

### Remove plaster

<?code-excerpt plaster="none"?>

<?code-excerpt "plaster.txt"?>
```
abc
def
```

<?code-excerpt "plaster.txt" plaster?>
```
abc
···
def
```

<?code-excerpt plaster?>

<?code-excerpt "plaster.txt"?>
```
abc
// Insert your code here ···
def
```

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
