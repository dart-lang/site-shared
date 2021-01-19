## Test: no code in code block, directive w/o indentation

<?code-excerpt "quote.md"?>
```
This is a **markdown** fragment.
```

## Test: no code in code block, directive with indentation

<?code-excerpt "quote.md" indent-by="2"?>
```
  This is a **markdown** fragment.
```

## Test: out-of-date code in code block, directive with indentation

<?code-excerpt "quote.md" indent-by="2"?>
```
  This is a **markdown** fragment.
```
