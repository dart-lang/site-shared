import 'dart:io';

import 'package:test/test.dart';
import 'package:code_excerpter/builder.dart';
import 'package:yaml/yaml.dart';

void main() {
  test('build.yaml build_extensions matches Builder', () {
    final buildYamlFile = File('build.yaml');
    final content = buildYamlFile.readAsStringSync();
    Map yaml = loadYaml(content);
    Map builders = yaml['builders'];
    expect(builders, isNotNull);
    Map code_excerpter = builders['code_excerpter'];
    expect(code_excerpter, isNotNull);
    Map build_extensions = code_excerpter['build_extensions'];
    expect(build_extensions, isNotNull);
    expect(build_extensions, builder(null).buildExtensions);
  });
}
