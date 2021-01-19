/// Test: no code in code block, directive with indentation
/// <?code-excerpt "basic.dart" region="greeting" indent-by="2"?>
/// ```dart
/// ```
void f() {}

/// Test: region name in path.
/// <?code-excerpt "basic.dart (greeting)"?>
/// ```dart
/// ```
class D {}

/// Test: region name in path.
/// <?code-excerpt "basic.dart (another greeting)"?>
/// ```dart
/// ```
class E {}
