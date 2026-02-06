import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legacyhub/core/services/local_storage_service.dart';
import 'package:legacyhub/core/services/logger_service.dart';
import 'package:legacyhub/routes/app_routes.dart';

/// Theme Controller - Manages theme selection during onboarding
///
/// Responsibilities:
/// - Handle theme selection (Dark, Light, System)
/// - Persist theme preference
/// - Apply theme to the app
/// - Navigate to language selection screen
class ThemeController extends GetxController {
  static ThemeController get instance => Get.find();

  // Selected theme mode (reactive) - defaults to light
  final Rx<ThemeMode> selectedTheme = ThemeMode.light.obs;

  // Track if system theme was changed
  final RxBool hasChangedTheme = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentTheme();
  }

  /// Load current theme from storage
  void _loadCurrentTheme() {
    try {
      final currentTheme = LocalStorageService.getThemeMode();
      // Default to light if system mode
      if (currentTheme == ThemeMode.system) {
        selectedTheme.value = ThemeMode.light;
        Get.changeThemeMode(ThemeMode.light);
      } else {
        selectedTheme.value = currentTheme;
      }
      LoggerService.info('Current theme loaded: ${selectedTheme.value.name}');
    } catch (error) {
      LoggerService.error('Error loading theme', error);
      selectedTheme.value = ThemeMode.light;
    }
  }

  /// Select a theme
  void selectTheme(ThemeMode themeMode) {
    try {
      selectedTheme.value = themeMode;

      // Apply theme immediately
      Get.changeThemeMode(themeMode);

      // Save to storage
      LocalStorageService.setThemeMode(themeMode);

      // Mark that theme has been changed (disables system theme option)
      if (themeMode != ThemeMode.system) {
        hasChangedTheme.value = true;
      }

      LoggerService.info('Theme changed to: ${themeMode.name}');
    } catch (error) {
      Get.changeThemeMode(ThemeMode.light);
      LoggerService.error('Error selecting theme', error);
    }
  }

  /// Check if a theme is selected
  bool isSelected(ThemeMode themeMode) {
    return selectedTheme.value == themeMode;
  }

  /// Get Lottie path for current theme
  String getLottiePath() {
    switch (selectedTheme.value) {
      case ThemeMode.dark:
        return 'assets/lottie/dark_night.json';
      case ThemeMode.light:
        return 'assets/lottie/light_sun_spin.json';
      case ThemeMode.system:
        // Determine based on system brightness
        final brightness = Get.theme.brightness;
        return brightness == Brightness.dark
            ? 'assets/lottie/dark_night.json'
            : 'assets/lottie/light_sun_spin.json';
    }
  }

  /// Get background color for current theme
  Color getBackgroundColor() {
    switch (selectedTheme.value) {
      case ThemeMode.dark:
        return const Color(0xFF1A1A2E);
      case ThemeMode.light:
        return const Color(0xFFEEEFFC);
      case ThemeMode.system:
        // final brightness = Get.theme.brightness;
        // return brightness == Brightness.dark
        //     ? const Color(0xFF1A1A2E)
        //     : const Color(0xFFEEEFFC);
        return const Color(0xFFEEEFFC);
    }
  }

  /// Navigate to language selection screen
  void navigateToLanguageScreen() {
    try {
      LoggerService.info('Navigating to Language Selection Screen');
      Get.toNamed(AppRoutes.getLanguageScreen());
    } catch (error) {
      LoggerService.error('Error navigating to language screen', error);
    }
  }

  /// Skip theme selection and go to language screen with system theme
  void skipThemeSelection() {
    try {
      // Save current selection and close screen
      LocalStorageService.setThemeMode(selectedTheme.value);
      LoggerService.info('Theme saved: ${selectedTheme.value.name}');

      // Go back to previous screen
      Get.back();
    } catch (error) {
      LoggerService.error('Error saving theme selection', error);
      Get.back();
    }
  }
}
