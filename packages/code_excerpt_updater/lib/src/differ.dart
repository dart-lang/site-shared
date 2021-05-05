import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;

import 'code_transformer/core.dart';
import 'constants.dart';
import 'diff/diff.dart';
import 'matcher.dart';
import 'nullable.dart';

typedef ErrorReporter = void Function(String msg);
typedef ExcerptFetcher = Iterable<String> Function(String path, String region);

class Differ {
  Differ(this._excerptFetcher, this._log, this._reportError);

  final docregionRe = RegExp(r'#(end)?doc(plaster|region)\b');
  final ExcerptFetcher _excerptFetcher;
  final ErrorReporter _reportError;
  final Logger _log;

  @nullable
  Directory _tmpDir;

  @nullable
  Iterable<String> getDiff(String relativeSrcPath1, String region,
      Map<String, String> args, String pathPrefix) {
    final relativeSrcPath2 = args['diff-with'];
    final useCompleteFiles = region.isEmpty && args['remove'] == null;
    final path1 = useCompleteFiles
        ? filteredFile(p.join(pathPrefix, relativeSrcPath1))
        : _writeExcerpt(relativeSrcPath1, region, args);
    final path2 = useCompleteFiles
        ? filteredFile(p.join(pathPrefix, relativeSrcPath2))
        : _writeExcerpt(relativeSrcPath2, region, args);

    final diffArgs = args['diff-u'] == null ? ['-u'] : ['-U', args['diff-u']];
    diffArgs.addAll([path1.path, path2.path]);
    final r = Process.runSync('diff', diffArgs);

    try {
      path1.deleteSync();
      path2.deleteSync();
    } on FileSystemException catch (e) {
      _log.info(
          'Ignored exception while attempting to delete temporary files: $e');
    }

    if (r.exitCode > 1) {
      _reportError(r.stderr as String);
      return null;
    }
    if ((r.stdout as String).isEmpty) return []; // no differences between files

    /* Sample diff output:
    --- examples/acx/lottery/1-base/lib/lottery_simulator.html	2017-08-25 07:45:24.000000000 -0400
    +++ examples/acx/lottery/2-starteasy/lib/lottery_simulator.html	2017-08-25 07:45:24.000000000 -0400
    @@ -23,35 +23,39 @@
         <div class="clear-floats"></div>
       </div>

    -  Progress: <strong>{{progress}}%</strong> <br>
    -  <progress max="100" [value]="progress"></progress>
    +  <material-progress  [activeProgress]="progress" class="life-progress">
    +  </material-progress>

       <div class="controls">
    ...
    */

    var diffText = (r.stdout as String).trim();
    final from = patternArgToMatcher(args['from']);
    final to = patternArgToMatcher(args['to']);
    if (from != null || to != null) {
      final diff = Diff(diffText);
      if (diff.keepLines(from: from, to: to)) diffText = diff.toString();
    }
    final result = diffText.split(eol);

    // Fix file id lines by removing:
    // - [pathPrefix] from the start of the file path so that paths are relative
    // - timestamp (because file timestamps are not relevant in the git world)
    result[0] = _adjustDiffFileIdLine(
        relativeSrcPath1 + (region.isEmpty ? '' : ' ($region)'), result[0]);
    result[1] = _adjustDiffFileIdLine(
        relativeSrcPath2 + (region.isEmpty ? '' : ' ($region)'), result[1]);
    _log.fine('>> diff result:\n${result.join("\n")}');
    return result;
  }

  /// Read the file at [filePath], strip out any docregion tags (lines matching
  /// [docregionRe]), write the result to a temporary file and return the
  /// corresponding [File] object.
  ///
  /// Lets [FileSystemException]s through.
  File filteredFile(String filePath) {
    final file = File(filePath);
    final src = file.readAsStringSync();
    final lines = src.split(eol);
    lines.removeWhere(docregionRe.hasMatch);

    return _writeTmp(filePath, lines.join(eol));
  }

  /// Write the named region of [filePath] to a temporary file whose filename
  /// is derived from [filePath]. Returns the [File] instance of the temp file.
  File _writeExcerpt(String filePath, String region, Map<String, String> args) {
    var excerpt = _excerptFetcher(filePath, region)?.join(eol) ?? '';

    final removeArg = args['remove'];
    if (removeArg != null) excerpt = removeCodeTransformer(removeArg)(excerpt);

    // To avoid "No newline at end of file" messages from the diff tool,
    // ensure that the excerpt ends with an EOL (since all trailing blank lines
    // are usually stripped out).
    if (excerpt.isNotEmpty) excerpt += eol;

    return _writeTmp(filePath, excerpt);
  }

  /// Write [content] to a temporary file whose filename is derived
  /// from [filePath]. Returns the temporary [File] instance.
  File _writeTmp(String filePath, String content) {
    final ext = p.extension(filePath);
    final tmpFilePath =
        p.join(getTmpDir().path, 'differ_src_${filePath.hashCode}$ext');
    final tmpFile = File(tmpFilePath);
    tmpFile.writeAsStringSync(content);
    return tmpFile;
  }

  //  int _indexOfFirstMatch(List a, int startingIdx, RegExp re) {
  //    var i = startingIdx;
  //    while (i < a.length && !re.hasMatch(a[i])) i++;
  //    return i;
  //  }

  final _diffFileIdRegEx = RegExp(r'^(---|\+\+\+) ([^\t]+)\t(.*)$');

  String _adjustDiffFileIdLine(String relativePath, String diffFileIdLine) {
    final line = diffFileIdLine;
    final match = _diffFileIdRegEx.firstMatch(line);
    if (match == null) {
      _log.warning('Warning: unexpected file Id line: $diffFileIdLine');
      return diffFileIdLine;
    }
    return '${match[1]} $relativePath';
  }

  Directory getTmpDir() =>
      _tmpDir ??= Directory.systemTemp; // .createTempSync();
}
