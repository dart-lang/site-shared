/// Test: multi line
///
/// <?code-excerpt "0-base/basic.dart" diff-with="1-step/basic.dart"?>
/// ```diff
/// --- 0-base/basic.dart
/// +++ 1-step/basic.dart
/// @@ -1,4 +1,4 @@
/// -var _greeting = 'hello';
/// +var _greeting = 'bonjour';
///  var _scope = 'world';
///
///  void main() => print('$_greeting $_scope');
/// ```
class C {}

/// <?code-excerpt "0-base/basic.dart" diff-with="0-base/basic.dart"?>
/// ```diff
/// ```
class D {}

/// <?code-excerpt "0-base/basic.dart" diff-with="1-step/basic.dart" to="+var"?>
/// ```diff
/// --- 0-base/basic.dart
/// +++ 1-step/basic.dart
/// @@ -1 +1 @@
/// -var _greeting = 'hello';
/// +var _greeting = 'bonjour';
/// ```
class E {}

/// <?code-excerpt "0-base/basic.dart" diff-with="1-step/basic.dart" from="-var" to="var"?>
/// ```diff
/// --- 0-base/basic.dart
/// +++ 1-step/basic.dart
/// @@ -1 +1 @@
/// -var _greeting = 'hello';
/// ```
class F {}
