/// This class exposes a singleton logger via [log].
///
/// The singleton logger is initialized as follows:
///
/// - If the build system logger is defined, that logger is used.
/// - Otherwise, create a new Logger named 'package:code_excerpter'
///

import 'dart:async';

import 'package:logging/logging.dart';

// Singleton logger
Logger _logger;

const _buildLogKey = #buildLog;
final _default = Logger('package:code_excerpter');

/// Initial logging level. It must be set before calling [log].
Level initLevel = Level.FINE;

Logger get log {
  if (_logger != null) return _logger;

  // Use build logger if there is one:
  _logger = Zone.current[_buildLogKey] as Logger;

  if (_logger == null) {
    _logger = _default;
    Logger.root.level = initLevel;
    Logger.root.onRecord.listen((r) => logListeners.forEach((h) => h(r)));
  }
  return _logger;
}

//---------------------------------------------------------

typedef LogListener = void Function(LogRecord);

final List<LogListener> logListeners = [
  printLogRecord,
];

void printLogRecord(LogRecord r) => print('${r.level.name}: ${r.message}');
