import 'dart:math';

import 'constants.dart';

// ignore_for_file: type_annotate_public_apis

/// String to int conversion
int toInt(String s, {int radix = 10, int errorValue}) {
  try {
    return int.parse(s, radix: radix);
  } on FormatException {
    return errorValue;
  }
}

//-----------------------------------------------------------------------------

final _blankLineRegEx = RegExp(r'^\s*$');
final _leadingWhitespaceRegEx = RegExp(r'^[ \t]*');

Iterable<String> trimMinLeadingSpace(Iterable<String> lines) {
  final nonblankLines = lines.where((s) => !_blankLineRegEx.hasMatch(s));
  // Length of leading spaces to be trimmed
  final lengths = nonblankLines.map((s) {
    final match = _leadingWhitespaceRegEx.firstMatch(s);
    return match == null ? 0 : match[0].length;
  });
  if (lengths.isEmpty) return lines;
  final len = lengths.reduce(min);
  return len == 0
      ? lines
      : lines.map((line) => line.length < len ? line : line.substring(len));
}

//-----------------------------------------------------------------------------
// TODO: consider writing the following conversions as a string transformer.

final escapedSlashRE = RegExp(r'\\/');

final _slashHexCharRE = RegExp(r'\\x(..)');
final _slashLetterRE = RegExp(r'\\([\\nt])');

/// Encode special characters: '\t', `\n`, and `\xHH` where `HH` are hex digits.
String encodeSlashChar(String s) => s
    .replaceAllMapped(_slashLetterRE, (Match m) => _slashCharToChar(m[1]))
    // At this point, escaped `\` is encoded as [zeroChar].
    .replaceAllMapped(_slashHexCharRE,
        (Match m) => _hexToChar(m[1], errorValue: '\\x${m[1]}'))
    // Recover `\` characters.
    .replaceAll(zeroChar, backslash);

String _hexToChar(String hexDigits, {String errorValue}) {
  final charCode = toInt(hexDigits, radix: 16);
  return charCode == null ? errorValue : String.fromCharCode(charCode);
}

//
String _slashCharToChar(String char) {
  switch (char) {
    case 'n':
      return '\n';
    case 't':
      return '\t';
    case backslash:
      return zeroChar;
    default:
      return '\\$char';
  }
}
