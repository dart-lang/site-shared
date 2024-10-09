// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:isolate';

import 'package:path/path.dart' as path;
import 'package:sass/sass.dart' as sass;
import 'package:test/test.dart';

void main() {
  test('Can build styles.scss file', () {
    final compileResult = sass.compileToResult(_stylesPath!);
    expect(compileResult.css, contains('--dash-default-font-family'));
  });
}

String? get _stylesPath {
  final packageUri = Uri.parse('package:dash_design/styles.scss');
  final resolvedUri = Isolate.resolvePackageUriSync(packageUri);
  if (resolvedUri == null) return null;
  if (!resolvedUri.isScheme('file')) return null;
  return path.fromUri(resolvedUri);
}
