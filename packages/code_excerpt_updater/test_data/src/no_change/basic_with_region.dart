/// Test: multi line
/// <?code-excerpt "basic.dart" region="greeting"?>
/// ```dart
/// var greeting = 'hello';
/// var scope = 'world';
/// ```
class C {}

/// Test: region name in path.
/// <?code-excerpt "basic.dart (greeting)"?>
/// ```dart
/// var greeting = 'hello';
/// var scope = 'world';
/// ```
class D {}

/// Test: region name in path.
/// <?code-excerpt "basic.dart (another()? greeting)"?>
/// ```dart
/// var greeting = 'hello';
/// var scope = 'world';
/// ```
class E {}
