import 'package:logging/logging.dart';

import 'nullable.dart';

final Logger _log = Logger('CEU.CT');

typedef Matcher = bool Function(String t);
// typedef Predicate<T> = bool Function(T t);

Matcher not(Matcher p) => (String s) => !p(s);

@nullable
Matcher patternArgToMatcher(String arg, [String cmd = '']) {
  if (arg == null) return null;
  Matcher matcher;
  if (arg.startsWith('/') && arg.endsWith('/')) {
    final re = RegExp(arg.substring(1, arg.length - 1));
    _log.finest(' >> $cmd arg: "$arg" used as regexp $re');
    matcher = re.hasMatch;
  } else {
    final stringToMatch = arg.startsWith(r'\/')
        ? arg.substring(1) // TODO: process other escaped characters
        : arg;
    _log.finest(' >> $cmd arg: "$stringToMatch" is used as a string matcher');
    matcher = (s) => s.contains(stringToMatch);
  }
  return matcher;
}
