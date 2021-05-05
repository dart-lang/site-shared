import 'package:code_excerpt_updater/src/diff/hunk.dart';
import 'package:code_excerpt_updater/src/matcher.dart';
import 'package:test/test.dart';

const hunk0 = '''
@@ -1,10 +1,12 @@
 import 'package:flutter/material.dart';
+import 'package:english_words/english_words.dart';

 void main() => runApp(MyApp());

''';

final hunk0ExtraBody1 = '''
 class MyApp extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
+    final wordPair = WordPair.random();
     return MaterialApp(
'''
    .trimRight();

final hunk0ExtraBody2 = '''
       title: 'Welcome to Flutter',
       home: Scaffold(
'''
    .trimRight();

final hunk0ExtraBody = '$hunk0ExtraBody1\n$hunk0ExtraBody2';

final hunk1 = '$hunk0$hunk0ExtraBody';

final hunk1TrimmedBefore = '@@ -5,6 +6,7 @@\n$hunk0ExtraBody';
final hunk1TrimmedBeforeAndAfter = '@@ -5,4 +6,5 @@\n$hunk0ExtraBody1';

final hunk2 = '''
@@ -12,7 +14,7 @@
           title: Text('Welcome to Flutter'),
         ),
         body: Center(
-          child: Text('Hello World'),
+          child: Text(wordPair.asPascalCase),
         ),
       ),
     );
'''
    .trim();

void main() {
  group('basic hunk 1', () {
    Hunk h;

    setUp(() {
      h = Hunk(hunk1);
    });

    test('Idempotence on src', () {
      expect(h.toString(), hunk1);
    });

    test('Line info', () {
      expect(h.start(0), 1);
      expect(h.start(1), 1);
      expect(h.length(0), 10);
      expect(h.length(1), 12);

      expect(() => h.start(2), throwsA(isA<AssertionError>()));
      expect(() => h.length(2), throwsA(isA<AssertionError>()));
    });

    test('Skip before "class"', () {
      expect(h.dropLinesUntil(patternArgToMatcher('/^ class/')), true);
      expect(h.toString(), hunk1TrimmedBefore);
    });

    test('Skip before "class" until "return"', () {
      expect(h.dropLinesUntil(patternArgToMatcher('/^ class/')), true);
      expect(h.dropLinesAfter(patternArgToMatcher(r'/^\s+return/')), true);
      expect(h.toString(), hunk1TrimmedBeforeAndAfter);
    });
  });

  group('basic hunk 2', () {
    Hunk h;

    setUp(() {
      h = Hunk(hunk2);
    });

    test('Idempotence on src', () {
      expect(h.toString(), hunk2);
    });

    test('Line info', () {
      expect(h.start(0), 12);
      expect(h.start(1), 14);
      expect(h.length(0), 7);
      expect(h.length(1), 7);
    });

    test('Skip before w/o match', () {
      final skipped = h.dropLinesUntil(patternArgToMatcher('xx'));
      expect(skipped, false);
      expect(h.toString(), hunk2);
    });
  });
}
