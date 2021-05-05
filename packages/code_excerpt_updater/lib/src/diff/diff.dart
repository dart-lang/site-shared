import '../matcher.dart';
import 'hunk.dart';

/// Representation of a unified diff
class Diff {
  final String _rawText;
  bool _parsed = false;

  final List<String> fileInfo = [null, null];
  List<Hunk> hunks;

  Diff(this._rawText);

  /// Keep hunk lines in between those lines that match [from] and [to],
  /// inclusive (matching is done on non-hunk-header lines). Drop all other
  /// lines. Omit [from], to keep lines as of the first line of the first hunk.
  /// Omit [to] to keep all lines after [from]. Returns true iff [from] or [to]
  /// matched.
  bool keepLines({Matcher from, Matcher to}) {
    if (!_parsed) _parse();
    var matchFound = false;
    if (from != null) {
      while (hunks.isNotEmpty) {
        final hunk = hunks.first;
        if (hunk.dropLinesUntil(from)) {
          matchFound = true;
          break;
        }
        hunks.removeAt(0);
      }
    }
    if (to == null) return matchFound;

    for (var i = 0; i < hunks.length; i++) {
      final hunk = hunks[i];
      if (hunk.dropLinesAfter(to)) {
        hunks = hunks.take(i + 1).toList();
        return true;
      }
    }
    return false;
  }

  bool dropLinesUntil(Matcher matcher) {
    if (!_parsed) _parse();
    while (hunks.isNotEmpty) {
      final hunk = hunks.first;
      if (hunk.dropLinesUntil(matcher)) return true;
      hunks.removeAt(0);
    }
    return false;
  }

  bool dropLinesAfter(Matcher matcher) {
    if (!_parsed) _parse();
    for (final hunk in hunks) {
      if (hunk.dropLinesAfter(matcher)) return true;
    }
    return false;
  }

  void _parse() {
    if (_parsed || _rawText.isEmpty) return;
    _parsed = true;
    final lines = _rawText.split(eol);

    fileInfo[0] = lines[0];
    fileInfo[1] = lines[1];

    var i = 2;
    hunks = [];
    while (i < lines.length) {
      if (!lines[i].startsWith('@@')) throw _invalidHunk(i);
      final start = i++;
      // Look for the start of the next hunk or the end of the diff
      while (i < lines.length && !lines[i].startsWith('@@')) {
        i++;
      }
      hunks.add(Hunk(lines.skip(start).take(i - start).join(eol)));
    }
  }

  @override
  String toString() => !_parsed
      ? _rawText
      : hunks.isEmpty
          ? fileInfo.join(eol)
          : '${fileInfo.join(eol)}\n${hunks.join(eol)}';

  Exception _invalidHunk(int lineNum) =>
      Exception('Invalid hunk syntax. Expected "@@" at line $lineNum.');
}
