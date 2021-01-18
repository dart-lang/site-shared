## Test: code fragment should be unindented

<?code-excerpt "indented_frag.dart (single code block)"?>
```
// Fragment is indented by 4 spaces
var x = 1;
return x;
```

## Test: code fragment should be unindented

<?code-excerpt "indented_frag.dart (code blocks)"?>
```
  // Fragment is indented by 4 spaces
  var x = 1;

/* ... */
     return x;
  /* ... */
```
