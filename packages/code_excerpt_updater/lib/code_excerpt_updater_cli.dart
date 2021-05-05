// Copyright (c) 2017. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:logging/logging.dart';

import 'src/code_excerpt_updater.dart';
import 'src/logger.dart';
import 'src/nullable.dart';

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

  final _parser = ArgParser()
    ..addFlag(_logFineFlagName)
    ..addMultiOption(_excludeFlagName,
        help: 'Paths to exclude when processing a directory recursively.\n'
            'Dot files and directorys are always excluded.',
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
        abbr: 'w',
        defaultsTo: false,
        negatable: false,
        help: 'Write updates to files in-place.')
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
      help: 'REPLACE-EXPRESSIONs. Global replace argument. '
          'See README for syntax.',
    )
    ..addFlag(_yamlFlagName,
        negatable: false, help: 'Read excerpts from *.excerpt.yaml files.');

  bool escapeNgInterpolation;
  List<String> excludePathRegExpStrings;
  List<RegExp> excludePathRegExp;
  bool excerptsYaml;
  bool failOnRefresh;
  String fragmentDirPath, replaceExpr, srcDirPath;
  @nullable
  String plasterTemplate;
  bool inPlaceFlag;
  int indentation;
  List<String> pathsToFileOrDir = [];
  Level logLevel;

  bool argsAreValid = false;

  int numErrors = 0;
  int numFiles = 0;
  int numSrcDirectives = 0;
  int numUpdatedFrag = 0;

  void setArgs(List<String> argsAsStrings) {
    ArgResults args;

    bool flag(String name) => (args[name] ?? false) as bool;
    String str(String name) => (args[name] ?? '') as String;

    try {
      args = _parser.parse(argsAsStrings);
    } on FormatException catch (e) {
      print('${e.message}\n');
      _printUsageAndExit(_parser, exitCode: 64);
    }
    pathsToFileOrDir = args.rest;

    if (flag('help')) _printHelpAndExit(_parser);

    var i = 0;
    if (args[_indentFlagName] != null) {
      try {
        i = int.parse(str(_indentFlagName));
      } on FormatException {
        _printUsageAndExit(_parser,
            msg: '$_indentFlagName: invalid value  "${args[_indentFlagName]}"');
      }
    }
    indentation = i;

    if (flag(_logFineFlagName)) logLevel = Level.FINE;

    if (pathsToFileOrDir.isEmpty) {
      _printUsageAndExit(_parser, msg: 'Expecting one or more path arguments');
    }
    escapeNgInterpolation = flag(_escapeNgInterpolationFlagName);
    excludePathRegExpStrings = args[_excludeFlagName] as List<String>;
    excerptsYaml = flag(_yamlFlagName);
    failOnRefresh = flag(_failOnRefresh);
    fragmentDirPath = str(_fragmentDirPathFlagName);
    inPlaceFlag = flag(_inPlaceFlagName);
    plasterTemplate = args[_plasterFlagName] == null
        ? null
        : args[_plasterFlagName] as String;
    replaceExpr = str(_replaceName);
    srcDirPath = str(_srcDirPathFlagName);

    excludePathRegExp = [
      _dotPathRe,
      ...excludePathRegExpStrings.map((p) => RegExp(p))
    ];
    argsAreValid = true;
  }

  /// Process files/directories given as CLI arguments.
  Future<void> processArgs() async {
    if (!argsAreValid) {
      throw Exception('Cannot proceed without valid arguments');
    }
    for (final entityPath in pathsToFileOrDir) {
      await _processEntity(entityPath, warnAboutNonDartFile: true);
    }
  }

  Future _processEntity(String path,
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
  Future _processDirectory(String dirPath) async {
    log.fine('_processDirectory: $dirPath');
    if (_exclude(dirPath)) return;
    final dir = Directory(dirPath);
    final entityList = dir.list(); // recursive: true, followLinks: false
    await for (FileSystemEntity fse in entityList) {
      final path = fse.path;
      final exclude =
          _exclude(path) || fse is File && !_validExt.hasMatch(path);
      log.finer('>> FileSystemEntity: $path ${exclude ? '- excluded' : ''}');
      if (exclude) continue;
      await (fse is Directory ? _processDirectory(path) : _processFile(path));
    }
  }

  Future _processFile(String path) async {
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

  Future _updateFile(String filePath) async {
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

  void _printHelpAndExit(ArgParser parser) {
    print('Use $_commandName to update code fragments within markdown '
        'code blocks preceded with <?code-excerpt?> directives. '
        '(See the tool\'s GitHub repo README for details.)\n');
    _printUsageAndExit(parser);
  }

  void _printUsageAndExit(ArgParser parser, {String msg, int exitCode = 1}) {
    if (msg != null) print('\n$msg\n');
    print('Usage: $_commandName [OPTIONS] file_or_directory...\n');
    print(parser.usage);
    exit(exitCode);
  }
}
