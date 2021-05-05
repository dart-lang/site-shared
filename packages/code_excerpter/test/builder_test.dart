import 'dart:io';

import 'package:code_excerpter/builder.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  test('build.yaml build_extensions matches Builder', () {
    final buildYamlFile = File('build.yaml');
    final content = buildYamlFile.readAsStringSync();
    final yaml = loadYaml(content) as YamlMap;
    final builders = yaml['builders'] as Map;
    expect(builders, isNotNull);
    final codeExcerpter = builders['code_excerpter'] as Map;
    expect(codeExcerpter, isNotNull);
    final buildExtensions = codeExcerpter['build_extensions'] as Map;
    expect(buildExtensions, isNotNull);
    expect(buildExtensions, builder(null).buildExtensions);
  });
}
