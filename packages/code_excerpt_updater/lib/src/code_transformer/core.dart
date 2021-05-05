/// Collected code transformer and predicate declarations
import '../constants.dart';
import '../matcher.dart';
import '../nullable.dart';
import '../util.dart';

typedef CodeTransformer = String Function(String code);

CodeTransformer compose(CodeTransformer f, CodeTransformer g) => f == null
    ? g
    : g == null
        ? f
        : (String s) => g(f(s));

CodeTransformer _retain(Matcher p) => (String code) {
      final lines = code.split(eol)..retainWhere(p);
      return lines.join(eol);
    };

//---
// Specific transformers
//---

@nullable
CodeTransformer fromCodeTransformer(String arg) {
  final matcher = patternArgToMatcher(arg, 'from');
  if (matcher == null) return null;
  return (String code) {
    final lines = code.split(eol).skipWhile(not(matcher));
    return lines.join(eol);
  };
}

@nullable
CodeTransformer removeCodeTransformer(String arg) {
  final matcher = patternArgToMatcher(arg, 'remove');
  return matcher == null ? null : _retain(not(matcher));
}

@nullable
CodeTransformer retainCodeTransformer(String arg) {
  final matcher = patternArgToMatcher(arg, 'retain');
  return matcher == null ? null : _retain(matcher);
}

@nullable
CodeTransformer skipCodeTransformer(String arg) {
  final n = toInt(arg);
  if (n == null) return null;
  return n >= 0
      ? (String code) => code.split(eol).skip(n).join(eol)
      : (String code) {
          final lines = code.split(eol);
          return lines.take(lines.length + n).join(eol);
        };
}

@nullable
CodeTransformer takeCodeTransformer(String arg) {
  final n = toInt(arg);
  if (n == null) return null;
  return n >= 0
      ? (String code) => code.split(eol).take(n).join(eol)
      : (String code) {
          final lines = code.split(eol);
          return lines.skip(lines.length + n - 1).join(eol);
        };
}

@nullable
CodeTransformer toCodeTransformer(String arg) {
  final matcher = patternArgToMatcher(arg, 'to');
  if (matcher == null) return null;
  return (String code) {
    final lines = code.split(eol);
    final i = _indexWhere(lines, matcher); // lines.indexWhere(matcher)
    if (i < 0) return code;
    return lines.take(i + 1).join(eol);
  };
}

/// Patch: 1.24.3 doesn't have Iterable.indexWhere(). Drop this once we drop 1.x
int _indexWhere(List<String> list, bool Function(String s) test) {
  for (var i = 0; i < list.length; i++) {
    if (test(list[i])) return i;
  }
  return -1;
}
