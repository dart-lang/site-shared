// Copyright (c) 2017. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io' as io;

import 'package:code_excerpt_updater/code_excerpt_updater_cli.dart';

/// See [UpdaterCLI].
Future<void> main(List<String> args) async {
  final updater = UpdaterCLI.fromArgs(args);
  await updater.process();
  final msg = 'Processed ${updater.numFiles} Dart/Jade/Markdown files: '
      '${updater.numUpdatedFrag} out of '
      '${updater.numSrcDirectives} fragments needed updating.';
  print(msg);
  final exitCode = updater.numErrors > 0
      ? updater.numErrors
      : updater.failOnRefresh && updater.numUpdatedFrag > 0
          ? updater.numUpdatedFrag
          : 0;
  io.exitCode = exitCode;
}
