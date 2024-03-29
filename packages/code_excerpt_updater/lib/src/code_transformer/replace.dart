import '../constants.dart';
import '../issue_reporter.dart';
import '../logger.dart';
import '../util.dart';
import 'core.dart';

class ReplaceCodeTransformer {
  static final RegExp _matchDollarNumRE = RegExp(r'(\$+)(&|\d*)');
  static final RegExp _endRE = RegExp(r'^g;?\s*$');

  final IssueReporter _reporter;

  ReplaceCodeTransformer(this._reporter);

  CodeTransformer? codeTransformer(String? replaceExp) {
    void reportErr([String extraInfo = '']) {
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
      reportErr('argument has missing parts ($len)');
      return null;
    }
    if (start != '') {
      reportErr('argument should start with "/", not  "$start"');
      return null;
    }
    final transformers = <CodeTransformer>[];
    for (var i = 1; i < replaceExpParts.length; i += 3) {
      final re = replaceExpParts[i];
      final replacement = replaceExpParts[i + 1];
      final end = replaceExpParts[i + 2];
      if (!_endRE.hasMatch(end)) {
        reportErr(
            'expected argument end syntax of "g" or "g;" but found "$end"');
        return null;
      }
      final transformer = codeTransformerHelper(re, replacement);
      transformers.add(transformer);
    }

    return transformers.fold(null, compose);
  }

  CodeTransformer codeTransformerHelper(String re, String replacement) {
    final encodedReplacement = encodeSlashChar(replacement);
    log.finest(' >> replacement expr: $encodedReplacement');

    if (!_matchDollarNumRE.hasMatch(encodedReplacement)) {
      return (String code) => code.replaceAll(RegExp(re), encodedReplacement);
    }

    return (String code) => code.replaceAllMapped(
          RegExp(re),
          (Match m) => encodedReplacement.replaceAllMapped(
            _matchDollarNumRE,
            (replaceMatch) {
              // In JS, $$ becomes $ in a replacement string.
              final numDollarChar = replaceMatch[1]!.length;
              // Escaped dollar characters, if any:
              final dollars = r'$' * (numDollarChar ~/ 2);

              final number = replaceMatch[2];

              // Even number of $'s, e.g. $$1?
              if (numDollarChar.isEven || number == null || number.isEmpty) {
                return '$dollars${replaceMatch[2]}';
              }

              if (number == '&') return '$dollars${m[0]}';

              final argNum = int.tryParse(number) ?? m.groupCount + 1;
              // No corresponding group? Return the arg, like in JavaScript.
              if (argNum > m.groupCount) return '$dollars\$$number';

              return '$dollars${m[argNum]}';
            },
          ),
        );
  }
}
