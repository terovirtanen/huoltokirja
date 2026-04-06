import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../l10n/app_localizations.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class HuoltokirjaApp extends StatelessWidget {
  const HuoltokirjaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: appRouter,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      localeListResolutionCallback: (locales, _) {
        final languageCodes =
            locales?.map((locale) => locale.languageCode).toSet() ??
            const <String>{};
        if (languageCodes.contains('en')) {
          return const Locale('en');
        }
        return const Locale('fi');
      },
    );
  }
}
