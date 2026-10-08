import 'package:flutter/widgets.dart';

import 'generated/app_localizations.dart';

export 'generated/app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// zh-CN is the default; any unsupported locale falls back to it.
Locale resolveAppLocale(Locale? locale, Iterable<Locale> supported) {
  if (locale != null) {
    for (final s in supported) {
      if (s.languageCode == locale.languageCode) return s;
    }
  }
  return const Locale('zh');
}
