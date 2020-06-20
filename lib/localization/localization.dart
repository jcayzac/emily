library localization;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'languages/languages.dart';

final tagTailPattern = new RegExp(r'-[0-9a-z]+$');

/// Supports all locales, with best-match resolution
class AppLocalizationsDelegate extends LocalizationsDelegate<Language> {
  const AppLocalizationsDelegate();

  @override
  Future<Language> load(Locale locale) {
    var localization;
    var languageTag = locale.toLanguageTag().toLowerCase();
    var tail;
    do {
      // We found a match!
      localization = languages[languageTag];
      if (localization != null) break;

      // Remove the last part…
      tail = tagTailPattern.firstMatch(languageTag);
      if (tail != null) languageTag = languageTag.substring(0, tail.start);
    } while (tail != null);
    if (localization == null) localization = languages['en'];

    Language.current = localization();
    return SynchronousFuture(Language.current);
  }

  @override
  bool isSupported(Locale locale) => true;

  @override
  bool shouldReload(LocalizationsDelegate<Language> old) => false;
}

/// Main class for app localizations
class AppLocalizations {
  /// Main entry point for app code
  static Language of(BuildContext context) =>
      Localizations.of<Language>(context, Language);

  /// Value for [MaterialApp.localeResolutionCallback].
  static final resolutionCallback =
      (Locale locale, Iterable<Locale> supportedLocales) => locale;

  /// Value for [MaterialApp.localizationsDelegates].
  static final delegates = <LocalizationsDelegate>[
    AppLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];
}
