import '../constants.dart';
import '../issue_reporter.dart';
import '../logger.dart';
import '../nullable.dart';
import '../util.dart';
import 'core.dart';

class ReplaceCodeTransformer {
  ReplaceCodeTransformer(this._reporter);

  final IssueReporter _reporter;

  final _matchDollarNumRE = RegExp(r'(\$+)(&|\d*)');
  final _endRE = RegExp(r'^g;?\s*$');

  @nullable
  CodeTransformer codeTransformer(String replaceExp) {
    void _reportErr([String extraInfo = '']) {
      _reporter.error(
        '${'invalid replace attribute ("$replaceExp"); '}'
        '${extraInfo.isEmpty ? '' : '$extraInfo; '}'
        'supported syntax is 1 or more semi-colon-separated: /regexp/replacement/g',
      );
    }

    if (replaceExp == null) return null;
    final replaceExpParts = replaceExp
        .replaceAll(escapedSlashRE, zeroChar)
        .split('/')
        .map((s) => s.replaceAll(zeroChar, '/'))
        .toList();

    // replaceExpParts = [''] + n x [re, replacement, end] where n >= 1 and
    // end matches _endRE.

    final start = replaceExpParts[0];
    final len = replaceExpParts.length;
    if (len < 4 || len % 3 != 1) {
      _reportErr('argument has missing parts ($len)');
      return null;
    }
    if (start != '') {
      _reportErr('argument should start with "/", not  "$start"');
      return null;
    }
    final transformers = <CodeTransformer>[];
    for (var i = 1; i < replaceExpParts.length; i += 3) {
      final re = replaceExpParts[i];
      final replacement = replaceExpParts[i + 1];
      final end = replaceExpParts[i + 2];
      if (!_endRE.hasMatch(end)) {
        _reportErr(
            'expected argument end syntax of "g" or "g;" but found "$end"');
        return null;
      }
      final transformer = codeTransformerHelper(re, replacement);
      if (transformer != null) transformers.add(transformer);
    }

    return transformers.fold(null, compose);
  }

  @nullable
  CodeTransformer codeTransformerHelper(String re, String _replacement) {
    final replacement = encodeSlashChar(_replacement);
    log.finest(' >> replacement expr: $replacement');

    if (!_matchDollarNumRE.hasMatch(replacement)) {
      return (String code) => code.replaceAll(RegExp(re), replacement);
    }

    return (String code) => code.replaceAllMapped(
        RegExp(re),
        (Match m) => replacement.replaceAllMapped(_matchDollarNumRE, (_m) {
              // In JS, $$ becomes $ in a replacement string.
              final numDollarChar = _m[1].length;
              // Escaped dollar characters, if any:
              final dollars = r'$' * (numDollarChar ~/ 2);

              // Even number of $'s, e.g. $$1?
              if (numDollarChar.isEven || _m[2].isEmpty) {
                return '$dollars${_m[2]}';
              }

              if (_m[2] == '&') return '$dollars${m[0]}';

              final argNum = toInt(_m[2], errorValue: m.groupCount + 1);
              // No corresponding group? Return the arg, like in JavaScript.
              if (argNum > m.groupCount) return '$dollars\$${_m[2]}';

              return '$dollars${m[argNum]}';
            }));
  }
}
