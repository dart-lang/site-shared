## Diff tests of code blocks in Jekyll `diff` tags

## Basic

<?code-excerpt "0-base/basic.dart" diff-with="1-step/basic.dart"?>
{% diff %}
--- 0-base/basic.dart
+++ 1-step/basic.dart
@@ -1,4 +1,4 @@
-var _greeting = 'hello';
+var _greeting = 'bonjour';
 var _scope = 'world';

 void main() => print('$_greeting $_scope');
{% enddiff %}

### Files with docregion tags

<?code-excerpt "0-base/docregion.dart" diff-with="1-step/docregion.dart"?>
{% diff %}
--- 0-base/docregion.dart
+++ 1-step/docregion.dart
@@ -1,4 +1,4 @@
-var _greeting = 'hello';
+var _greeting = 'bonjour';
 var _scope = 'world';

 /// Some
@@ -12,4 +12,4 @@
 /// two
 /// diff
 /// hunks
-void main() => print('$_greeting $_scope');
+void main() => print('$_greeting $_scope!');
{% enddiff %}

### Diff region

<?code-excerpt "0-base/docregion.dart (main)" diff-with="1-step/docregion.dart"?>
{% diff %}
--- 0-base/docregion.dart (main)
+++ 1-step/docregion.dart (main)
@@ -1 +1 @@
-void main() => print('$_greeting $_scope');
+void main() => print('$_greeting $_scope!');
{% enddiff %}

### Files with docregion tags and diff-u argument

<?code-excerpt "0-base/docregion.dart" diff-with="1-step/docregion.dart" diff-u="4"?>
{% diff %}
--- 0-base/docregion.dart
+++ 1-step/docregion.dart
@@ -1,5 +1,5 @@
-var _greeting = 'hello';
+var _greeting = 'bonjour';
 var _scope = 'world';

 /// Some
 /// doc
@@ -11,5 +11,5 @@
 /// get
 /// two
 /// diff
 /// hunks
-void main() => print('$_greeting $_scope');
+void main() => print('$_greeting $_scope!');
{% enddiff %}

## Bash path-brace syntax for diffs

<?code-excerpt "{0-base,1-step}/basic.dart"?>
```diff
--- 0-base/basic.dart
+++ 1-step/basic.dart
@@ -1,4 +1,4 @@
-var _greeting = 'hello';
+var _greeting = 'bonjour';
 var _scope = 'world';

 void main() => print('$_greeting $_scope');
```

## Bash path-brace syntax with diff-with error

<?code-excerpt "{0-base,1-step}/basic.dart" diff-with="abc"?>
```diff
--- 0-base/basic.dart
+++ 1-step/basic.dart
@@ -1,4 +1,4 @@
-var _greeting = 'hello';
+var _greeting = 'bonjour';
 var _scope = 'world';

 void main() => print('$_greeting $_scope');
```

## Remove argument

<?code-excerpt "{0-base,1-step}/basic.dart" remove="var _scope"?>
```diff
--- 0-base/basic.dart
+++ 1-step/basic.dart
@@ -1,3 +1,3 @@
-var _greeting = 'hello';
+var _greeting = 'bonjour';

 void main() => print('$_greeting $_scope');
```
