import 'dart:async';

import 'package:build/build.dart';

import 'src/excerpter.dart';
import 'src/util/line.dart';

const excerptLineLeftBorderChar = '|';

Builder builder(BuilderOptions options) => CodeExcerptBuilder(options);

class CodeExcerptBuilder implements Builder {
  final outputExtension = '.excerpt.yaml';

  BuilderOptions options;

  CodeExcerptBuilder(this.options);

  @override
  Future<void> build(BuildStep buildStep) async {
    final assetId = buildStep.inputId;
    if (assetId.package.startsWith(r'$') || assetId.path.endsWith(r'$')) return;

    final content = await buildStep.readAsString(assetId);
    final outputAssetId = assetId.addExtension(outputExtension);

    final excerpter = Excerpter(assetId.path, content);
    final yaml = _toYaml(excerpter.weave().excerpts);
    if (yaml.isNotEmpty) {
      await buildStep.writeAsString(outputAssetId, yaml);
      log.info('wrote $outputAssetId');
    } else {
      // log.warning(' $outputAssetId has no excerpts');
    }
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        '': [outputExtension]
      };

  String _toYaml(Map<String, List<String>> excerpts) {
    if (excerpts.isEmpty) return '';

    const yamlExcerptLeftBorderCharKey = '#border';
    final s = StringBuffer();

    s.writeln("'$yamlExcerptLeftBorderCharKey': '$excerptLineLeftBorderChar'");
    excerpts.forEach((name, lines) {
      s.writeln(_yamlEntry(name, lines));
    });
    return s.toString();
  }

  String _yamlEntry(String regionName, List<String> lines) {
    final codeAsYamlStringValue = lines
        // YAML multiline string: indent by 2 spaces.
        .map((line) => '  $excerptLineLeftBorderChar$line')
        .join(eol);
    return "'$regionName': |+\n$codeAsYamlStringValue";
  }
}
