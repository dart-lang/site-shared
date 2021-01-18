/// Representation of an XML processing instruction
class InstrInfo {
  final String instruction;
  String linePrefix = '';

  InstrInfo(this.instruction);

  /// Optional. Currently represents a path + optional region
  String unnamedArg;

  String _path;
  String get path => _path ?? args['path'] ?? '';
  set path(String p) {
    _path = p;
  }

  String _region;
  set region(String r) {
    _region = r;
  }

  String get region => args['region'] ?? _region ?? '';

  final Map<String, String> args = {};

  @override
  String toString() => 'InstrInfo: $linePrefix$instruction; args=$args';
}
