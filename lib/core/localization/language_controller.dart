import 'dart:ui';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_template/core/localization/languages.dart';

/// Language Controller for managing app language settings
/// Handles language switching, persistence, and system locale detection
class LanguageController extends GetxController {
  // Storage service for persisting language preference
  final GetStorage _storage = GetStorage();

  // Storage key for language preference
  static const String _languageKey = 'selected_language';

  // Current locale reactive variable
  final Rx<Locale> _currentLocale = Languages.locale.obs;

  /// Get current locale
  Locale get currentLocale => _currentLocale.value;

  /// Get current language code
  String get currentLanguageCode => _currentLocale.value.languageCode;

  /// Get current language name for display
  String get currentLanguageName =>
      Languages.getLanguageName(_currentLocale.value);

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }

  /// Load saved language from storage or use system locale
  void _loadSavedLanguage() {
    try {
      // Check if user has saved a language preference
      final savedLangCode = _storage.read(_languageKey);

      if (savedLangCode != null &&
          Languages.langCodes.containsKey(savedLangCode)) {
        // Use saved language
        final savedLocale = Languages.langCodes[savedLangCode]!;
        _setLocale(savedLocale);
        // Log.info('Loaded saved language: ${savedLocale.languageCode}');
      } else {
        // Try to use system locale, fallback to default if not supported
        _setSystemOrDefaultLocale();
      }
    } catch (error) {
      // Log.error('Error loading saved language: $error', error: error);
      _setLocale(Languages.locale); // Fallback to default
    }
  }

  /// Set system locale if supported, otherwise use default
  void _setSystemOrDefaultLocale() {
    final systemLocale = Get.deviceLocale;

    if (systemLocale != null && Languages.isSupported(systemLocale)) {
      _setLocale(systemLocale);
      // Log.info('Using system locale: ${systemLocale.languageCode}');
    } else {
      _setLocale(Languages.locale);
      // Log.info('Using default locale: ${Languages.locale.languageCode}');
    }
  }

  /// Change app language
  /// [locale] - The locale to change to
  Future<void> changeLanguage(Locale locale) async {
    try {
      if (!Languages.isSupported(locale)) {
        // Log.warning('Unsupported locale: $locale');
        return;
      }

      await _setLocale(locale);
      await _saveLanguagePreference(locale.languageCode);

      // Log.info('Language changed to: ${locale.languageCode}');
    } catch (error) {
      // Log.error('Error changing language: $error', error: error);
    }
  }

  /// Change language by language code
  /// [languageCode] - The language code (e.g., 'en', 'bn')
  Future<void> changeLanguageByCode(String languageCode) async {
    final locale = Languages.langCodes[languageCode];
    if (locale != null) {
      await changeLanguage(locale);
    } else {
      // Log.warning('Unknown language code: $languageCode');
    }
  }

  /// Set locale and update GetX
  Future<void> _setLocale(Locale locale) async {
    _currentLocale.value = locale;
    await Get.updateLocale(locale);
    update(); // Notify listeners
  }

  /// Save language preference to storage
  Future<void> _saveLanguagePreference(String languageCode) async {
    try {
      await _storage.write(_languageKey, languageCode);
    } catch (error) {
      // Log.error('Error saving language preference: $error', error: error);
    }
  }

  /// Get all supported languages for UI display
  Map<String, String> getSupportedLanguages() {
    return Languages.languageNames;
  }

  /// Check if given locale is currently active
  bool isCurrentLanguage(Locale locale) {
    return _currentLocale.value.languageCode == locale.languageCode &&
        _currentLocale.value.countryCode == locale.countryCode;
  }

  /// Check if given language code is currently active
  bool isCurrentLanguageCode(String languageCode) {
    return _currentLocale.value.languageCode == languageCode;
  }

  /// Reset language to system default
  Future<void> resetToSystemLanguage() async {
    try {
      await _storage.remove(_languageKey);
      _setSystemOrDefaultLocale();
      // Log.info('Language reset to system default');
    } catch (error) {
      // Log.error('Error resetting language: $error', error: error);
    }
  }
}
