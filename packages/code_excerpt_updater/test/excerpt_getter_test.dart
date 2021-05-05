import 'package:code_excerpt_updater/src/excerpt_getter.dart';
import 'package:code_excerpt_updater/src/issue_reporter.dart';
import 'package:code_excerpt_updater/src/nullable.dart';
import 'package:test/test.dart';

const _testDir = 'test_data';

void main() {
  const excerptsYaml = true;
  const fragmentDirPath = '$_testDir/excerpt_yaml';
  const srcDirPath = fragmentDirPath;
  final _reporter =
      IssueReporter(IssueContext(() => 'unused/path/to/file', () => 1));

  @nullable
  ExcerptGetter eg;

  setUpAll(() {
    eg = ExcerptGetter(excerptsYaml, fragmentDirPath, srcDirPath, _reporter)
      ..pathBase = '';
  });

  test('sanity', () {
    final excerpt = eg.getExcerpt('excerpt_getter.dart', 'main');
    final code = [r"void main() => print('$greeting $scope');"];
    expect(excerpt, code);
  });

  test('trim trailing blank lines', () {
    final excerpt =
        eg.getExcerpt('excerpt_getter.dart', 'trailing blank lines');
    final code = [r"var greeting = 'hello';"];
    expect(excerpt, code);
  });

  test('main with border', () {
    final excerpt = eg.getExcerpt('excerpt_getter_with_border.dart', 'main');
    final code = [r"void main() => print('$greeting $scope');"];
    expect(excerpt, code);
  });

  test('trailing blank lines with border', () {
    final excerpt = eg.getExcerpt(
        'excerpt_getter_with_border.dart', 'trailing blank lines');
    final code = [r"var greeting = 'hello';"];
    expect(excerpt, code);
  });
}
