import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n =>
      AppLocalizations.of(this) ?? lookupAppLocalizations(const Locale('fi'));

  String formatDate(DateTime date) {
    return MaterialLocalizations.of(this).formatShortDate(date);
  }
}
