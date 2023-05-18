/// Exposes a singleton logger via [log].
///
/// The singleton logger is initialized as follows:
///
/// - If the build system logger is defined, that logger is used.
/// - Otherwise, create a new Logger named 'package:code_excerpter'
///
library;

import 'dart:async';

import 'package:logging/logging.dart';

const _buildLogKey = #buildLog;

/// Initial logging level. It must be set before calling [log].
Level initLevel = Level.FINE;

/// The build logger or if there isn't one, a new default logger.
final Logger log = () {
  // Use build logger if there is one:
  var logger = Zone.current[_buildLogKey] as Logger?;

  if (logger == null) {
    logger = Logger('package:code_excerpter');
    Logger.root.level = initLevel;
    Logger.root.onRecord.listen((r) {
      for (final h in logListeners) {
        h(r);
      }
    });
  }

  return logger;
}();

//---------------------------------------------------------

typedef LogListener = void Function(LogRecord);

final List<LogListener> logListeners = [
  printLogRecord,
];

void printLogRecord(LogRecord r) => print('${r.level.name}: ${r.message}');
