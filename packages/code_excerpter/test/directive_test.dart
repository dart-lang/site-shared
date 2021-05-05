import 'package:code_excerpter/src/directive.dart';
import 'package:test/test.dart';

void main() {
  group('basic', () {
    test('not a directive', () {
      final d = Directive.tryParse('');
      expect(d, isNull);
    });

    test(Kind.startRegion, () {
      final d = Directive.tryParse('#docregion');
      expect(d.kind, Kind.startRegion);
      expect(d.rawArgs, '');
      expect(d.args, []);
    });

    test(Kind.endRegion, () {
      final d = Directive.tryParse('#enddocregion');
      expect(d.kind, Kind.endRegion);
      expect(d.rawArgs, '');
      expect(d.args, []);
    });
  });

  // Leading and trailing text is ignored
  group('context insenstivie', () {
    test(Kind.startRegion, () {
      const spaces = '  ';
      final d = Directive.tryParse('$spaces// #docregion');
      expect(d.kind, Kind.startRegion);
      expect(d.rawArgs, '');
      expect(d.args, []);
      expect(d.indentation, spaces);
    });

    test(Kind.endRegion, () {
      final d = Directive.tryParse(' #enddocregion a,b,  c  ');
      expect(d.kind, Kind.endRegion);
      expect(d.rawArgs, 'a,b,  c');
      expect(d.args, ['a', 'b', 'c']);
      expect(d.indentation, ' ');
    });
  });

  group('close comment syntax:', () {
    group('HTML:', () {
      test(Kind.startRegion, () {
        final d = Directive.tryParse('<!--#docregion-->');
        expect(d.kind, Kind.startRegion);
        expect(d.rawArgs, '');
        expect(d.args, []);
        expect(d.indentation, '');
      });

      test(Kind.endRegion, () {
        final d = Directive.tryParse('<!-- #enddocregion a -->  ');
        expect(d.kind, Kind.endRegion);
        expect(d.rawArgs, 'a');
        expect(d.args, ['a']);
        expect(d.indentation, '');
      });
    });

    group('CSS:', () {
      test(Kind.startRegion, () {
        final d = Directive.tryParse('/*#docregion*/');
        expect(d.kind, Kind.startRegion);
        expect(d.rawArgs, '');
        expect(d.args, []);
        expect(d.indentation, '');
      });

      test(Kind.endRegion, () {
        final d = Directive.tryParse('/* #enddocregion a */  ');
        expect(d.kind, Kind.endRegion);
        expect(d.rawArgs, 'a');
        expect(d.args, ['a']);
        expect(d.indentation, '');
      });
    });
  });

  group('problem cases:', () {
    test('Deprecated unquoted default region name', () {
      final d = Directive.tryParse('#docregion ,a');
      expect(d.kind, Kind.startRegion);
      expect(d.rawArgs, ',a');
      expect(d.args, ['', 'a']);
      expect(d.issues, ['unquoted default region name is deprecated']);
    });

    test('Duplicate "a" region', () {
      final d = Directive.tryParse('#docregion a,b,c,a');
      expect(d.kind, Kind.startRegion);
      expect(d.rawArgs, 'a,b,c,a');
      expect(d.args, ['a', 'b', 'c']);
      expect(d.issues, ['repeated argument "a"']);
    });

    test('Duplicate "" region', () {
      final d = Directive.tryParse("#docregion '',''");
      expect(d.kind, Kind.startRegion);
      expect(d.rawArgs, "'',''");
      expect(d.args, ['']);
      expect(d.issues, ['repeated argument ""']);
    });
  });
}
