import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import 'code_transformer/core.dart';
import 'constants.dart';
import 'issue_reporter.dart';
import 'logger.dart';
import 'nullable.dart';
import 'util.dart';

const _defaultYamlExcerptLeftBorderChar = ''; // I.e., no char by default
const _yamlExcerptLeftBorderCharKey = '#border';

class ExcerptGetter {
  ExcerptGetter(
      this.excerptsYaml, this.fragmentDirPath, this.srcDirPath, this._reporter);

  final bool excerptsYaml;
  final String fragmentDirPath;
  final String srcDirPath;
  final IssueReporter _reporter;

  String pathBase = '';
  String _yamlExcerptLeftBorderChar = _defaultYamlExcerptLeftBorderChar;

  @nullable
  Iterable<String> getExcerpt(
      // String pathBase,
      String relativePath,
      String region,
      [CodeTransformer t]) {
    _yamlExcerptLeftBorderChar = _defaultYamlExcerptLeftBorderChar;
    var excerpt = _getExcerptAsString(relativePath, region);
    if (excerpt == null) return null; // Errors have been reported
    log.fine('>> excerpt before xform: "$excerpt"');
    if (_yamlExcerptLeftBorderChar.isNotEmpty) {
      excerpt = _removeLineBorderPrefix(_yamlExcerptLeftBorderChar, excerpt);
    }
    if (t != null) excerpt = t(excerpt);
    final lines = excerpt.split(eol);
    // All excerpts are [eol] terminated, so drop trailing blank lines
    while (lines.isNotEmpty && lines.last == '') {
      lines.removeLast();
    }
    return trimMinLeadingSpace(lines);
  }

  String _removeLineBorderPrefix(String borderChar, String excerpt) => excerpt
      .split(eol)
      .map((line) => line.startsWith(_yamlExcerptLeftBorderChar)
          ? line.substring(1)
          : line)
      .join(eol);

  /// Look for a fragment file under [fragmentDirPath], failing that look for a
  /// source file under [srcDirPath]. If a file is found return its content as
  /// a string. Otherwise, report an error and return null.
  @nullable
  String _getExcerptAsString(String relativePath, String region) => excerptsYaml
      ? _getExcerptAsStringFromYaml(relativePath, region)
      : _getExcerptAsStringLegacy(relativePath, region);

  /// Potentially assigns to _yamlExcerptLeftBorderChar the
  /// value of the YAML [_yamlExcerptLeftBorderCharKey] key.
  @nullable
  String _getExcerptAsStringFromYaml(String relativePath, String region) {
    const ext = '.excerpt.yaml';
    final excerptYamlPath =
        p.join(fragmentDirPath, pathBase, relativePath + ext);
    YamlMap excerptsYaml;
    try {
      final contents = File(excerptYamlPath).readAsStringSync();
      excerptsYaml =
          loadYaml(contents, sourceUrl: Uri.file(excerptYamlPath)) as YamlMap;
      _yamlExcerptLeftBorderChar =
          (excerptsYaml[_yamlExcerptLeftBorderCharKey] ?? '') as String;
    } on FileSystemException {
      // Fall through
    }
    if (region.isEmpty && excerptsYaml == null) {
      // Continue: search for source file.
    } else if (excerptsYaml == null) {
      _reporter.error('cannot read file "$excerptYamlPath"');
      return null;
    } else if (excerptsYaml[region] == null) {
      _reporter.error('there is no "$region" region in "$excerptYamlPath"');
      return null;
    } else {
      return (excerptsYaml[region] as String).trimRight();
    }

    // ...
    final filePath = p.join(fragmentDirPath, pathBase, relativePath);
    try {
      return File(filePath).readAsStringSync();
    } on FileSystemException {
      _reporter.error('excerpt not found for "$relativePath"');
      return null;
    }
  }

  @nullable
  String _getExcerptAsStringLegacy(String relativePath, String region) {
    const fragExtension = '.txt';
    var file = relativePath + fragExtension;
    if (region.isNotEmpty) {
      final dir = p.dirname(relativePath);
      final basename = p.basenameWithoutExtension(relativePath);
      final ext = p.extension(relativePath);
      file = p.join(dir, '$basename-$region$ext$fragExtension');
    }

    // First look for a matching fragment
    final fragPath = p.join(fragmentDirPath, pathBase, file);
    try {
      return File(fragPath).readAsStringSync();
    } on FileSystemException {
      if (region != '') {
        _reporter.error('cannot read fragment file "$fragPath"');
        return null;
      }
      // Fall through
    }

    // No fragment file file. Look for a source file with a matching file name.
    final srcFilePath = p.join(srcDirPath, pathBase, relativePath);
    try {
      return File(srcFilePath).readAsStringSync();
    } on FileSystemException {
      _reporter.error('cannot find a source file "$srcFilePath", '
          'nor fragment file "$fragPath"');
      return null;
    }
  }
}
