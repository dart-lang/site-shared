import 'package:logging/logging.dart';

final Logger log = Logger('CEU');

bool _loggerInitialized = false;

void initLogger([Level logLevel]) {
  if (_loggerInitialized) return;
  Logger.root.level = logLevel ?? Level.WARNING;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
  _loggerInitialized = true;
}
