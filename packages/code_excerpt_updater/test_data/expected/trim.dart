// ignore_for_file: type_annotate_public_apis
/// Test: trimming of whitespace from frag lines
/// <?code-excerpt "frag_with_trailing_whitespace.dart"?>
/// ```dart
/// // In fragment file, the const declaration line ends with: TAB SPACE
/// // (Beware: some editors trim out trailing whitespace!)
/// const c = 1;
/// ```
int v;
