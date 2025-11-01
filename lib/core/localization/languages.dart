import 'dart:ui';
import 'package:get/get.dart';
import 'package:project_template/core/localization/languages/en_us.dart';
import 'package:project_template/core/localization/languages/bn_bd.dart';

/// Multi-language support configuration for the application
/// Uses GetX internationalization system
class Languages extends Translations {
  /// Default locale for the app
  static const locale = Locale('en', 'US');

  /// Fallback locale when translation is not found
  static const fallbackLocale = Locale('en', 'US');

  /// List of all supported locales
  /// Note: Bengali uses 'bn' without country code for better Flutter compatibility
  static const supportedLocales = [
    Locale('en', 'US'), // English (US)
    Locale('bn'), // Bengali (generic for better Flutter support)
  ];

  /// Language codes mapping for easier access
  static const langCodes = {
    'en': Locale('en', 'US'),
    'bn': Locale('bn'), // Generic Bengali for better Flutter compatibility
  };

  /// Language names for display in UI
  static const Map<String, String> languageNames = {
    'en': 'English',
    'bn': 'বাংলা',
  };

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'bn': bnBD, // Use generic 'bn' key for better compatibility
  };

  /// Get language name by locale
  static String getLanguageName(Locale locale) {
    String key = locale.languageCode;
    return languageNames[key] ?? 'English';
  }

  /// Check if locale is supported
  static bool isSupported(Locale locale) {
    return supportedLocales.any((l) => l.languageCode == locale.languageCode);
  }
}
