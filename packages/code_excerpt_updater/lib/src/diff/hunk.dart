import '../matcher.dart';

const eol = '\n';

/// A unified-diff hunk consisting of a line-range header followed by the
/// unified diff line details. For example:
///
///     @@ -1,10 +1,12 @@
///      import 'package:flutter/material.dart';
///     +import 'package:english_words/english_words.dart';
///
///      void main() => runApp(MyApp());
///
///      class MyApp extends StatelessWidget {
///        @override
///        Widget build(BuildContext context) {
///     +    final wordPair = WordPair.random();
///          return MaterialApp(
///            title: 'Welcome to Flutter',
///            home: Scaffold(
class Hunk {
  static final Hunk empty = Hunk('');

  final headRegExp = RegExp(r'@@ -(\d+)(,(\d+))? \+(\d+)(,(\d+))? @@(.*)');

  String _rawText;
  bool _parsed = false;

  String _rawHead = '';
  List<int> _start;
  List< /*@nullable*/ int> _length;
  String _timeStamp = '';
  List<String> _lines;

  Hunk(String textFormat) {
    _rawText = textFormat ?? '';
    if (_rawText.isNotEmpty) _parse();
  }

  void _parse() {
    if (_parsed) return;

    final srcLines = _rawText.split(eol);
    _rawText = '';
    _rawHead = srcLines.first;
    _lines = srcLines.skip(1).toList();

    final m = headRegExp.firstMatch(_rawHead);
    assert(m != null);

    _start = [_int(m[1]), _int(m[4])];
    _length = [_int(m[3]) ?? 1, _int(m[6]) ?? 1];
    _timeStamp = m[7];
    _parsed = true;

    assert(_rawHead == _head, '_rawHead: $_rawHead\n_head:$_head');
  }

  int start(int i) {
    assert(isValidFileIndex(i));
    return _start[i];
  }

  int length(int i) {
    assert(isValidFileIndex(i));
    return _length[i];
  }

  /// Drop lines (excluding the header), until a line if found
  /// that matches [m]. The matching line is not dropped.
  /// @returns true iff a matching line was found.
  bool dropLinesUntil(Matcher m) {
    final indexOfMatch = _indexOfFirstMatch(_lines, m);
    if (indexOfMatch >= _lines.length) return false;

    for (var i = 0; i < indexOfMatch; i++) {
      if (_lines[i].startsWith('-')) {
        _start[0]++;
        _length[0]--;
      } else if (_lines[i].startsWith('+')) {
        _start[1]++;
        _length[1]--;
      } else {
        _start[0]++;
        _length[0]--;
        _start[1]++;
        _length[1]--;
      }
    }

    final rest = _lines.skip(indexOfMatch).toList();
    _lines = rest;
    return true; // new Hunk('$head\n$rest');
  }

  /// Look for a line (excluding the header), that matches [m].
  /// All lines after the match are dropped.
  /// @returns true iff a matching line was found.
  bool dropLinesAfter(Matcher m) {
    final indexOfMatch = _indexOfFirstMatch(_lines, m);
    if (indexOfMatch >= _lines.length) return false;

    for (var i = indexOfMatch + 1; i < _lines.length; i++) {
      if (_lines[i].startsWith('-')) {
        _length[0]--;
      } else if (_lines[i].startsWith('+')) {
        _length[1]--;
      } else {
        _length[0]--;
        _length[1]--;
      }
    }
    _lines = _lines.take(indexOfMatch + 1).toList();
    return true;
  }

  String get _head => '@@ -${_lineLength(0)} +${_lineLength(1)} @@$_timeStamp';

  @override
  String toString() => _parsed ? '$_head\n${_lines.join(eol)}' : _rawText;

  String _lineLength(int i) {
    assert(isValidFileIndex(i));
    return _length[i] == null || _length[i] <= 1
        ? '${_start[i]}'
        : '${_start[i]},${_length[i]}';
  }

  bool isValidFileIndex(int i) => i == 0 || i == 1;

  int _int(String s) {
    if (s == null) return null;
    try {
      // Can't use tryParse() since this code needs to run under 1.x as well.
      return int.parse(s);
    } catch (e) {
      return null;
    }
  }

  int _indexOfFirstMatch(List<String> a, Matcher m) {
    var i = 0;
    while (i < a.length && !m(a[i])) {
      i++;
    }
    return i;
  }
}
