import 'dart:io';

class IssueReporter {
  final IssueContext _ctx;
  final Stdout _stderr;

  int numWarnings = 0;
  int numErrors = 0;

  IssueReporter(this._ctx, [Stdout? err]) : _stderr = err ?? stderr;

  void warn(String msg) {
    numWarnings++;
    return _report('Warning', msg);
  }

  void error(String msg) {
    numErrors++;
    return _report('Error', msg);
  }

  void _report(String prefix, String msg) =>
      _stderr.writeln('$prefix: ${_ctx.filePath}:${_ctx.lineNum} $msg');
}

class IssueContext {
  final String Function() _filePath;
  final int Function() _lineNum;

  const IssueContext(this._filePath, this._lineNum);

  String get filePath => _filePath();
  int get lineNum => _lineNum();
}
