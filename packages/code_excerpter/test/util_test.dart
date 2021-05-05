import 'package:code_excerpter/src/util/line.dart';
import 'package:test/test.dart';

void main() {
  group('maxUnindent', () {
    test('empty list', () {
      expect(maxUnindent([]), []);
    });

    test('no leading space', () {
      final lines = <String>['abc'];
      expect(maxUnindent(lines), lines);
    });

    test('with leading space', () {
      final lines = <String>['  abc'];
      expect(maxUnindent(lines), ['abc']);
    });

    test('trim one leading space', () {
      final lines = <String>['  abc', ' def'];
      expect(maxUnindent(lines), [' abc', 'def']);
    });

    test('ignore blank lines', () {
      final lines = <String>[
        '  abc',
        ' ',
        '  ',
        ' def',
        '',
        '  ',
      ];
      dropTrailingBlankLines(lines);
      expect(maxUnindent(lines), [' abc', '', ' ', 'def']);
    });
  });
}
