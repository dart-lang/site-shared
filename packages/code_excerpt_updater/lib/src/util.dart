import 'dart:math';

import 'constants.dart';

/// String to int conversion
int? toInt(String? s, {int radix = 10, int? errorValue}) {
  if (s == null) {
    return errorValue;
  }
  try {
    return int.parse(s, radix: radix);
  } on FormatException {
    return errorValue;
  }
}

//-----------------------------------------------------------------------------

final RegExp _blankLineRegEx = RegExp(r'^\s*$');
final RegExp _leadingWhitespaceRegEx = RegExp(r'^[ \t]*');

Iterable<String> trimMinLeadingSpace(Iterable<String> lines) {
  final nonBlankLines = lines.where((s) => !_blankLineRegEx.hasMatch(s));

  // Length of leading spaces to be trimmed
  final lengths = nonBlankLines.map((s) {
    final matchLength = _leadingWhitespaceRegEx.firstMatch(s)?[0]?.length;
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

//-----------------------------------------------------------------------------
// TODO: consider writing the following conversions as a string transformer.

final RegExp escapedSlashRE = RegExp(r'\\/');

final RegExp _slashHexCharRE = RegExp(r'\\x(..)');
final RegExp _slashLetterRE = RegExp(r'\\([\\nt])');

/// Encode special characters: '\t', `\n`, and `\xHH` where `HH` are hex digits.
String encodeSlashChar(String s) => s
    .replaceAllMapped(_slashLetterRE, (Match m) => _slashCharToChar(m[1]))
    // At this point, escaped `\` is encoded as [zeroChar].
    .replaceAllMapped(_slashHexCharRE,
        (Match m) => _hexToChar(m[1], errorValue: '\\x${m[1]}'))
    // Recover `\` characters.
    .replaceAll(zeroChar, backslash);

String _hexToChar(String? hexDigits, {required String errorValue}) {
  final charCode = toInt(hexDigits, radix: 16);
  return charCode == null ? errorValue : String.fromCharCode(charCode);
}

String _slashCharToChar(String? char) {
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
