import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legacyhub/core/services/local_storage_service.dart';
import 'package:legacyhub/core/services/logger_service.dart';
import 'package:legacyhub/routes/app_routes.dart';

/// Theme Controller - Manages theme selection during onboarding
///
/// Responsibilities:
/// - Handle theme selection (Dark, Light only - NO System mode)
/// - Persist theme preference
/// - Apply theme to the app
/// - Navigate to language selection screen
class ThemeController extends GetxController {
  static ThemeController get instance => Get.find();

  // Selected theme mode (reactive) - defaults to light
  final Rx<ThemeMode> selectedTheme = ThemeMode.light.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentTheme();
  }

  /// Load current theme from storage
  void _loadCurrentTheme() {
    try {
      final currentTheme = LocalStorageService.getThemeMode();
      // Always default to light mode, never use system mode
      if (currentTheme == ThemeMode.system) {
        selectedTheme.value = ThemeMode.light;
        LocalStorageService.setThemeMode(ThemeMode.light);
        applyTheme(ThemeMode.light);
      } else {
        selectedTheme.value = currentTheme;
        applyTheme(currentTheme);
      }
      LoggerService.info('Current theme loaded: ${selectedTheme.value.name}');
    } catch (error) {
      LoggerService.error('Error loading theme', error);
      selectedTheme.value = ThemeMode.light;
      LocalStorageService.setThemeMode(ThemeMode.light);
      applyTheme(ThemeMode.light);
    }
  }

  /// Apply theme immediately to the app
  void applyTheme(ThemeMode themeMode) {
    try {
      Get.changeThemeMode(themeMode);
    } catch (e) {
      LoggerService.error('Error applying theme', e);
    }
  }

  /// Select a theme
  void selectTheme(ThemeMode themeMode) {
    try {
      selectedTheme.value = themeMode;

      // Save to storage first
      LocalStorageService.setThemeMode(themeMode);

      // Apply theme immediately
      applyTheme(themeMode);

      LoggerService.info('Theme changed to: ${themeMode.name}');
    } catch (error) {
      applyTheme(ThemeMode.light);
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
      case ThemeMode.system:
      // ignore: unreachable_switch_default
      default:
        return 'assets/lottie/light_sun_spin.json';
    }
  }

  /// Get background color for current theme
  Color getBackgroundColor() {
    switch (selectedTheme.value) {
      case ThemeMode.dark:
        return const Color(0xFF1A1A2E);
      case ThemeMode.light:
      case ThemeMode.system:
      // ignore: unreachable_switch_default
      default:
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

  /// Skip theme selection and navigate to next screen
  void skipThemeSelection() {
    try {
      // Save current selection
      LocalStorageService.setThemeMode(selectedTheme.value);
      // Ensure theme is applied immediately
      applyTheme(selectedTheme.value);
      LoggerService.info(
        'Theme saved and applied: ${selectedTheme.value.name}',
      );

      // Small delay to ensure theme is fully applied before navigation
      Future.delayed(const Duration(milliseconds: 100), () {
        Get.toNamed(AppRoutes.LANGUAGE_SELECTION);
      });
    } catch (error) {
      LoggerService.error('Error saving theme selection', error);
      Get.toNamed(AppRoutes.LANGUAGE_SELECTION);
    }
  }
}
