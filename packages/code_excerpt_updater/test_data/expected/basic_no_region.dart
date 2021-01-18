/// No region arguments in this file.

/// Test: no code in code block, directive w/o indentation
/// <?code-excerpt "no_region.html"?>
/// ```html
/// <div>
///   <h1>Hello World!</h1>
/// </div>
/// ```
int basic1;

/// Test: no code in code block, directive with indentation
/// <?code-excerpt "no_region.dart" indent-by="2"?>
/// ```dart
///   var greeting = 'hello';
///   var scope = 'world';
/// ```
num basic2;

/// Test: out-of-date code in code block, directive with indentation
/// <?code-excerpt "no_region.dart" indent-by="2"?>
/// ```dart
///   var greeting = 'hello';
///   var scope = 'world';
/// ```
dynamic basic3;
