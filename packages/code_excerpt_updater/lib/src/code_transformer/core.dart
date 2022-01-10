/// Collected code transformer and predicate declarations
import '../constants.dart';
import '../matcher.dart';
import '../util.dart';

typedef CodeTransformer = String Function(String code);

CodeTransformer? compose(CodeTransformer? f, CodeTransformer? g) {
  if (f == null) {
    return g;
  }
  if (g == null) {
    return f;
  }
  return (String s) => g(f(s));
}

CodeTransformer _retain(Matcher p) => (String code) {
      final lines = code.split(eol)..retainWhere(p);
      return lines.join(eol);
    };

//---
// Specific transformers
//---

CodeTransformer fromCodeTransformer(String arg) {
  final matcher = patternArgToMatcher(arg, 'from');
  return (String code) {
    final lines = code.split(eol).skipWhile(not(matcher));
    return lines.join(eol);
  };
}

CodeTransformer removeCodeTransformer(String arg) {
  final matcher = patternArgToMatcher(arg, 'remove');
  return _retain(not(matcher));
}

CodeTransformer retainCodeTransformer(String arg) {
  final matcher = patternArgToMatcher(arg, 'retain');
  return _retain(matcher);
}

CodeTransformer? skipCodeTransformer(String arg) {
  final n = toInt(arg);
  if (n == null) return null;
  return n >= 0
      ? (String code) => code.split(eol).skip(n).join(eol)
      : (String code) {
          final lines = code.split(eol);
          return lines.take(lines.length + n).join(eol);
        };
}

CodeTransformer? takeCodeTransformer(String arg) {
  final n = toInt(arg);
  if (n == null) return null;
  return n >= 0
      ? (String code) => code.split(eol).take(n).join(eol)
      : (String code) {
          final lines = code.split(eol);
          return lines.skip(lines.length + n - 1).join(eol);
        };
}

CodeTransformer toCodeTransformer(String arg) {
  final matcher = patternArgToMatcher(arg, 'to');
  return (String code) {
    final lines = code.split(eol);
    final i = lines.indexWhere(matcher);
    if (i < 0) return code;
    return lines.take(i + 1).join(eol);
  };
}
