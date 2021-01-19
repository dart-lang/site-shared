## Test: no code in code block, directive w/o indentation

<?code-excerpt "quote.md"?>
```
```

## Test: no code in code block, directive with indentation

<?code-excerpt "quote.md" indent-by="2"?>
```
```

## Test: out-of-date code in code block, directive with indentation

<?code-excerpt "quote.md" indent-by="2"?>
```
  we don't care what this text is since it will be replaced
misindented text that we don't care about
```
