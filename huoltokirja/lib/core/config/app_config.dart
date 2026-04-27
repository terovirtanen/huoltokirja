class AppConfig {
  static const appName = 'Huoltokirja';
  static const appVersion = '1.0.1';
  static const appBuildDate = String.fromEnvironment(
    'APP_BUILD_DATE',
    defaultValue: '2026-04-09',
  );
  static const dbName = 'huoltokirja.db';
  static const dbVersion = 8;
}
