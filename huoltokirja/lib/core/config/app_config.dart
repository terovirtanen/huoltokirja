import 'package:package_info_plus/package_info_plus.dart';

class AppConfig {
  static const appName = 'Huoltokirja';
  /// Populated from the platform (pubspec `version`) by [loadVersion].
  static String appVersion = 'unknown';

  static Future<void> loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    appVersion = info.version;
  }

  static const appBuildDate = String.fromEnvironment(
    'APP_BUILD_DATE',
    defaultValue: '2026-04-09',
  );
  static const dbName = 'huoltokirja.db';
  static const dbVersion = 8;
}
