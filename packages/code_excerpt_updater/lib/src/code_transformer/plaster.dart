import 'core.dart';
import 'replace.dart';

const defaultPlaster = '···';

class PlasterCodeTransformer {
  final bool excerptsYaml;

  final ReplaceCodeTransformer _replace;

  PlasterCodeTransformer(this.excerptsYaml, this._replace);

  /// Replace raw plaster markers in excerpt with [plasterTemplate].
  /// Note that plaster line indentation is not affected.
  ///
  /// If [plasterTemplate] is 'none' then plasters are removed.
  /// If [plasterTemplate] is null then a default [lang] specific plaster
  /// template is used.
  CodeTransformer? codeTransformer(String? plasterTemplate, String lang) {
    if (plasterTemplate == 'none') return removeCodeTransformer(defaultPlaster);
    if (!excerptsYaml) return null;

    final template =
        plasterTemplate?.replaceAll(r'$defaultPlaster', defaultPlaster) ??
            _plasterTemplateFor(lang);
    return template == null
        ? null
        : _replace.codeTransformerHelper(defaultPlaster, template);
  }

  String? _plasterTemplateFor(String lang) {
    switch (lang) {
      case 'css':
        return '/* $defaultPlaster */';

      case 'html':
        return '<!-- $defaultPlaster -->';

      case 'dart':
      case 'js':
      case 'scss':
      case 'ts':
        return '// $defaultPlaster';

      case 'yaml':
        return '# $defaultPlaster';

      case 'diff':
      default:
        return null;
    }
  }
}
