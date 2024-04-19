
import 'package:chicken_combat/common/langkey.dart';
import 'package:chicken_combat/common/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class LocalizationsConfig {
  static Locale getCurrentLocale() {

    return Locale("en");
  }

  static const List<Locale> supportedLocales = [
    Locale(LangKey.langVi, 'VN'),
    Locale(LangKey.langEn, 'EN'),
  ];

  static const List<LocalizationsDelegate> localizationsDelegates = [
    // A class which loads the translations from JSON files
    AppLocalizations.delegate,
    // Built-in localization of basic text for Material widgets
    GlobalMaterialLocalizations.delegate,
    // Built-in localization for text direction LTR/RTL
    GlobalWidgetsLocalizations.delegate,

    GlobalCupertinoLocalizations.delegate,
  ];

  static Locale? localeResolutionCallback(
      Locale? locale, List<Locale> supportedLocales) {
    // Check if the current device locale is supported
    if(locale!=null) {
      for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode ||
          supportedLocale.countryCode == locale.countryCode) {
        return supportedLocale;
      }
    }
    }

    // If the locale of the device is not supported, use the first one
    // from the list (English, in this case).
    return supportedLocales.first;
  }
}
