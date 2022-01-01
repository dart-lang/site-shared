import 'dart:math' show min;

const eol = '\n';

final blankLine = RegExp(r'^\s*$');
final _leadingWhitespace = RegExp(r'^[ \t]*');

/// WARNING: this method potentially mutates its argument.
void dropTrailingBlankLines(List<String> lines) {
  // Drop any blank lines at the end of lines
  while (lines.isNotEmpty && blankLine.hasMatch(lines.last)) {
    lines.removeLast();
  }
}

/// Unindent [lines] to the extent possible without losing
/// the relative inter-line indentation. Note that blank
/// lines are ignored in the process computing the maximal
/// left-shift.
Iterable<String> maxUnindent(Iterable<String> lines) {
  final nonBlankLines = lines.where((s) => !blankLine.hasMatch(s));

  // Length of leading spaces to be trimmed
  final lengths = nonBlankLines.map((s) {
    final matchLength = _leadingWhitespace.firstMatch(s)?[0]?.length;
    return matchLength ?? 0;
  });

  if (lengths.isEmpty) {
    return lines;
  }

  final len = lengths.reduce(min);
  return len == 0
      ? lines
      : lines.map((line) => line.length < len ? line : line.substring(len));
}
