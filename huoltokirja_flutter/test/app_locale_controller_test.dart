import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:huoltokirja_flutter/app/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test(
    'locale controller defaults to system locale and persists override',
    () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(appLocaleControllerProvider), isNull);

      await container
          .read(appLocaleControllerProvider.notifier)
          .setLocale(const Locale('en'));

      expect(container.read(appLocaleControllerProvider), const Locale('en'));

      final preferences = await SharedPreferences.getInstance();
      expect(preferences.getString('selected_locale'), 'en');

      await container
          .read(appLocaleControllerProvider.notifier)
          .useSystemLocale();

      expect(container.read(appLocaleControllerProvider), isNull);
      expect(preferences.getString('selected_locale'), isNull);
    },
  );
}
