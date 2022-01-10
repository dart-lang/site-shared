// Copyright (c) 2017. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:logging/logging.dart';

import 'src/code_excerpt_updater.dart';
import 'src/logger.dart';

const _commandName = 'code_excerpt_updater';
final _validExt = RegExp(r'\.(dart|jade|md)$');
final _dotPathRe = RegExp(r'(^|/)\..*($|/)');

/// Processes `.dart` and `.md` files, recursively traverses directories
/// using [Updater]. See this command's help for CLI argument details.
class UpdaterCLI {
  static const _logFineFlagName = 'log-fine';
  static const _escapeNgInterpolationFlagName = 'escape-ng-interpolation';
  static const _excludeFlagName = 'exclude';
  static const _failOnRefresh = 'fail-on-refresh';
  static const _fragmentDirPathFlagName = 'fragment-dir-path';
  static const _inPlaceFlagName = 'write-in-place';
  static const _indentFlagName = 'indentation';
  static const _plasterFlagName = 'plaster';
  static const _srcDirPathFlagName = 'src-dir-path';
  static const _yamlFlagName = 'yaml';

  static const _defaultPath =
      '(defaults to "", that is, the current working directory)';
  static const _replaceName = 'replace';

  static final _parser = ArgParser()
    ..addFlag(_logFineFlagName)
    ..addMultiOption(_excludeFlagName,
        help: 'Paths to exclude when processing a directory recursively.\n'
            'Dot files and directories are always excluded.',
        valueHelp: 'PATH_REGEXP,...')
    ..addFlag(_failOnRefresh,
        negatable: false,
        help: 'Report a non-zero '
            'exit code if a fragment is refreshed.')
    ..addOption(_fragmentDirPathFlagName,
        abbr: 'p',
        help:
            'PATH to directory containing code fragment files\n$_defaultPath.')
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show command help.')
    ..addOption(
      _indentFlagName,
      abbr: 'i',
      defaultsTo: '0',
      help: 'NUMBER. Default number of spaces to use as indentation for code '
          'inside code blocks.',
    )
    ..addOption(_srcDirPathFlagName,
        abbr: 'q',
        help: 'PATH to directory containing code used in diffs\n$_defaultPath.')
    ..addFlag(_inPlaceFlagName,
        abbr: 'w', negatable: false, help: 'Write updates to files in-place.')
    ..addFlag(_escapeNgInterpolationFlagName,
        defaultsTo: true,
        help: 'Escape Angular interpolation syntax {{...}} as {!{...}!}.')
    ..addOption(
      _plasterFlagName,
      help: 'TEMPLATE. Default plaster template to use for all files.\n'
          'For example, "// Insert your code here"; use "none" to remove plasters.',
    )
    ..addOption(
      _replaceName,
      help: 'REPLACE-EXPRESSIONS. Global replace argument. '
          'See README for syntax.',
    )
    ..addFlag(_yamlFlagName,
        negatable: false, help: 'Read excerpts from *.excerpt.yaml files.');

  final bool escapeNgInterpolation;
  final List<String> excludePathRegExpStrings;
  final List<RegExp> excludePathRegExp;
  final bool excerptsYaml;
  final bool failOnRefresh;
  final String fragmentDirPath;
  final String replaceExpr;
  final String srcDirPath;
  final String? plasterTemplate;
  final bool inPlaceFlag;
  final int indentation;
  final List<String> pathsToFileOrDir;
  final Level? logLevel;

  int numErrors = 0;
  int numFiles = 0;
  int numSrcDirectives = 0;
  int numUpdatedFrag = 0;

  UpdaterCLI._(
      this.escapeNgInterpolation,
      this.excludePathRegExpStrings,
      this.excludePathRegExp,
      this.excerptsYaml,
      this.failOnRefresh,
      this.fragmentDirPath,
      this.replaceExpr,
      this.srcDirPath,
      this.plasterTemplate,
      this.inPlaceFlag,
      this.indentation,
      this.pathsToFileOrDir,
      this.logLevel);

  factory UpdaterCLI.fromArgs(List<String> argsAsStrings) {
    final ArgResults args;

    try {
      args = _parser.parse(argsAsStrings);
    } on FormatException catch (e) {
      print('${e.message}\n');
      _printUsageAndExit(_parser, exitCode: 64);
    }

    bool flag(String name) => args[name] as bool? ?? false;

    final pathsToFileOrDir = args.rest;

    if (flag('help')) _printHelpAndExit(_parser);

    String str(String name) => args[name] as String? ?? '';

    var i = 0;
    if (args[_indentFlagName] != null) {
      try {
        i = int.parse(str(_indentFlagName));
      } on FormatException {
        _printUsageAndExit(_parser,
            msg: '$_indentFlagName: invalid value  "${args[_indentFlagName]}"');
      }
    }
    final indentation = i;

    final logLevel = flag(_logFineFlagName) ? Level.FINE : null;

    if (pathsToFileOrDir.isEmpty) {
      _printUsageAndExit(_parser, msg: 'Expecting one or more path arguments');
    }

    final escapeNgInterpolation = flag(_escapeNgInterpolationFlagName);
    final excludePathRegExpStrings = args[_excludeFlagName] as List<String>;
    final excerptsYaml = flag(_yamlFlagName);
    final failOnRefresh = flag(_failOnRefresh);
    final fragmentDirPath = str(_fragmentDirPathFlagName);
    final inPlaceFlag = flag(_inPlaceFlagName);
    final plasterTemplate = args[_plasterFlagName] == null
        ? null
        : args[_plasterFlagName] as String;
    final replaceExpr = str(_replaceName);
    final srcDirPath = str(_srcDirPathFlagName);

    final excludePathRegExp = [
      _dotPathRe,
      ...excludePathRegExpStrings.map(RegExp.new)
    ];

    return UpdaterCLI._(
        escapeNgInterpolation,
        excludePathRegExpStrings,
        excludePathRegExp,
        excerptsYaml,
        failOnRefresh,
        fragmentDirPath,
        replaceExpr,
        srcDirPath,
        plasterTemplate,
        inPlaceFlag,
        indentation,
        pathsToFileOrDir,
        logLevel);
  }

  /// Process files/directories given as CLI arguments.
  Future<void> process() async {
    for (final entityPath in pathsToFileOrDir) {
      await _processEntity(entityPath, warnAboutNonDartFile: true);
    }
  }

  Future<void> _processEntity(String path,
      {bool warnAboutNonDartFile = false}) async {
    final type = await FileSystemEntity.type(path);
    switch (type) {
      case FileSystemEntityType.directory:
        return _processDirectory(path);
      case FileSystemEntityType.file:
        if (_validExt.hasMatch(path)) return _processFile(path);
    }
    if (warnAboutNonDartFile) {
      final kind =
          type == FileSystemEntityType.notFound ? 'existent' : 'Dart/Markdown';
      stderr.writeln('Warning: skipping non-$kind file "$path" ($type)');
    }
  }

  /// Process (recursively) the entities in the directory [dirPath], ignoring
  /// non-Dart and non-directory entities.
  Future<void> _processDirectory(String dirPath) async {
    log.fine('_processDirectory: $dirPath');
    if (_exclude(dirPath)) return;
    final dir = Directory(dirPath);
    final fileEntityList = dir.list(); // recursive: true, followLinks: false
    await for (final fse in fileEntityList) {
      final path = fse.path;
      final exclude =
          _exclude(path) || fse is File && !_validExt.hasMatch(path);
      log.finer('>> FileSystemEntity: $path ${exclude ? '- excluded' : ''}');
      if (exclude) continue;
      await (fse is Directory ? _processDirectory(path) : _processFile(path));
    }
  }

  Future<void> _processFile(String path) async {
    try {
      await _updateFile(path);
      numFiles++;
      log.info('_processFile: $path');
    } catch (e, _) {
      numErrors++;
      stderr.writeln('Error processing "$path": $e'); // \n$_
      exitCode = 2;
    }
  }

  bool _exclude(String path) => excludePathRegExp.any((e) => path.contains(e));

  Future<void> _updateFile(String filePath) async {
    final updater = Updater(
      fragmentDirPath,
      srcDirPath,
      defaultIndentation: indentation,
      escapeNgInterpolation: escapeNgInterpolation,
      globalPlasterTemplate: plasterTemplate,
      globalReplaceExpr: replaceExpr,
      excerptsYaml: excerptsYaml,
      logLevel: logLevel,
    );
    final result = updater.generateUpdatedFile(filePath);

    numErrors += updater.numErrors;
    numSrcDirectives += updater.numSrcDirectives;
    numUpdatedFrag += updater.numUpdatedFrag;

    if (!inPlaceFlag) {
      print(result);
    } else if (updater.numUpdatedFrag > 0) {
      await File(filePath).writeAsString(result);
    }
  }
}

Never _printHelpAndExit(ArgParser parser) {
  print('Use $_commandName to update code fragments within markdown '
      'code blocks preceded with <?code-excerpt?> directives. '
      '(See the tool\'s GitHub repo README for details.)\n');
  _printUsageAndExit(parser);
}

Never _printUsageAndExit(ArgParser parser, {String? msg, int exitCode = 1}) {
  if (msg != null) print('\n$msg\n');
  print('Usage: $_commandName [OPTIONS] file_or_directory...\n');
  print(parser.usage);
  exit(exitCode);
}
