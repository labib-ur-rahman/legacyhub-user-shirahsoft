import 'dart:ui';
import 'package:get/get.dart';
import 'package:legacyhub/core/services/local_storage_service.dart';
import 'package:legacyhub/core/services/logger_service.dart';

/// Onboarding Language Controller - Manages language selection during onboarding
///
/// Responsibilities:
/// - Handle language selection (English, Bangla)
/// - Persist language preference
/// - Apply language to the app
/// - Mark first-time onboarding as complete
/// - Navigate to login screen
class OnboardingLanguageController extends GetxController {
  static OnboardingLanguageController get instance => Get.find();

  // Selected language (reactive) - defaults to English
  final Rx<Locale> selectedLanguage = const Locale('en', 'US').obs;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentLanguage();
  }

  /// Load current language from storage or use default (English)
  void _loadCurrentLanguage() {
    try {
      final currentLocale = LocalStorageService.getLocale();
      selectedLanguage.value = currentLocale;
      LoggerService.info(
        'Current language loaded: ${currentLocale.languageCode}',
      );
    } catch (error) {
      LoggerService.error('Error loading language', error);
      // Default to English
      selectedLanguage.value = const Locale('en', 'US');
    }
  }

  /// Select a language
  Future<void> selectLanguage(Locale locale) async {
    try {
      selectedLanguage.value = locale;

      // Apply language immediately
      await Get.updateLocale(locale);

      // Save to storage
      LocalStorageService.setLocale(locale);

      LoggerService.info('Language changed to: ${locale.languageCode}');
    } catch (error) {
      LoggerService.error('Error selecting language', error);
    }
  }

  /// Check if a language is selected
  bool isSelected(Locale locale) {
    return selectedLanguage.value.languageCode == locale.languageCode;
  }

  /// Get Lottie path for selected language
  String getLottiePath() {
    switch (selectedLanguage.value.languageCode) {
      case 'en':
        return 'assets/lottie/all_country_flags.json';
      case 'bn':
        return 'assets/lottie/bangladesh_flag.json';
      default:
        return 'assets/lottie/bangladesh_flag.json';
    }
  }

  /// Complete onboarding and close the screen
  Future<void> completeOnboarding() async {
    try {
      LoggerService.info(
        'Language selection completed: ${selectedLanguage.value.languageCode}',
      );

      // Save and close screen
      Get.back();
    } catch (error) {
      LoggerService.error('Error completing language selection', error);
      Get.back();
    }
  }

  /// Select English language
  Future<void> selectEnglish() async {
    await selectLanguage(const Locale('en', 'US'));
  }

  /// Select Bangla language
  Future<void> selectBangla() async {
    await selectLanguage(const Locale('bn', 'BD'));
  }
}
