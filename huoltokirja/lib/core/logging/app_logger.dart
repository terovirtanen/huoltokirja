import 'package:logging/logging.dart';

final Logger appLogger = Logger('Huoltokirja');

void configureLogging() {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    // Using print here keeps logging simple and works on all Flutter targets.
    // ignore: avoid_print
    print('[${record.level.name}] ${record.loggerName}: ${record.message}');
  });
}
