import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legacyhub/core/services/local_storage_service.dart';

/// ============================================================================
/// APP HELPERS - Easy Access Utility Functions
/// ============================================================================
/// Provides simple, centralized access to app-wide settings and preferences
///
/// Features:
/// - Current theme mode access
/// - Current language/locale access
/// - Theme-aware color helpers
/// - Background color based on theme
///
/// Usage Examples:
///   // Get current theme mode
///   final theme = AppHelpers.currentThemeMode;
///   final isDark = AppHelpers.isDarkMode;
///
///   // Get current language
///   final language = AppHelpers.currentLanguage;
///   final isBangla = AppHelpers.isBangla;
///
///   // Get theme-aware colors
///   final bgColor = AppHelpers.getBackgroundColor();
/// ============================================================================

class AppHelpers {
  // Prevent instantiation
  AppHelpers._();

  // ============================================================================
  // THEME MODE HELPERS
  // ============================================================================

  /// Get current theme mode from storage
  /// Returns ThemeMode.light or ThemeMode.dark (never System)
  ///
  /// Example:
  ///   final themeMode = AppHelpers.currentThemeMode;
  ///   // Returns: ThemeMode.dark or ThemeMode.light
  static ThemeMode get currentThemeMode {
    return LocalStorageService.getThemeMode();
  }

  /// Check if current theme is dark mode
  ///
  /// Example:
  ///   if (AppHelpers.isDarkMode) {
  ///     // Apply dark theme styles
  ///   }
  static bool get isDarkMode {
    return currentThemeMode == ThemeMode.dark;
  }

  /// Check if current theme is light mode
  ///
  /// Example:
  ///   if (AppHelpers.isLightMode) {
  ///     // Apply light theme styles
  ///   }
  static bool get isLightMode {
    return currentThemeMode == ThemeMode.light;
  }

  /// Get background color based on current theme
  /// Returns dark background (#1A1A2E) for dark mode
  /// Returns light background (#EEEFFC) for light mode
  ///
  /// Example:
  ///   Container(color: AppHelpers.getBackgroundColor())
  static Color getBackgroundColor() {
    return isDarkMode ? const Color(0xFF1A1A2E) : const Color(0xFFEEEFFC);
  }

  // ============================================================================
  // LANGUAGE/LOCALE HELPERS
  // ============================================================================

  /// Get current locale from storage or GetX
  /// Returns Locale('en', 'US') or Locale('bn', 'BD')
  ///
  /// Example:
  ///   final locale = AppHelpers.currentLocale;
  ///   print(locale.languageCode); // 'en' or 'bn'
  static Locale get currentLocale {
    // Try to get from GetX first (active locale)
    final getxLocale = Get.locale;
    if (getxLocale != null) {
      return getxLocale;
    }

    // Fallback to storage
    return LocalStorageService.getLocale();
  }

  /// Get current language code ('en' or 'bn')
  ///
  /// Example:
  ///   final langCode = AppHelpers.currentLanguage;
  ///   // Returns: 'en' or 'bn'
  static String get currentLanguage {
    return currentLocale.languageCode;
  }

  /// Check if current language is Bangla
  ///
  /// Example:
  ///   if (AppHelpers.isBangla) {
  ///     // Show Bangla-specific UI
  ///   }
  static bool get isBangla {
    return currentLanguage == 'bn';
  }

  /// Check if current language is English
  ///
  /// Example:
  ///   if (AppHelpers.isEnglish) {
  ///     // Show English-specific UI
  ///   }
  static bool get isEnglish {
    return currentLanguage == 'en';
  }

  // ============================================================================
  // THEME + LANGUAGE COMBINATION HELPERS
  // ============================================================================

  /// Get text color based on theme mode
  /// Returns white for dark mode, dark gray for light mode
  ///
  /// Example:
  ///   Text('Hello', style: TextStyle(color: AppHelpers.getTextColor()))
  static Color getTextColor() {
    return isDarkMode ? Colors.white : const Color(0xFF1A1A2E);
  }

  /// Get secondary text color based on theme mode
  /// Returns white70 for dark mode, gray for light mode
  ///
  /// Example:
  ///   Text('Subtitle', style: TextStyle(color: AppHelpers.getSecondaryTextColor()))
  static Color getSecondaryTextColor() {
    return isDarkMode ? Colors.white70 : const Color(0xFF6B7280);
  }

  // ============================================================================
  // CONVENIENCE METHODS
  // ============================================================================

  /// Get localized greeting based on time and language
  ///
  /// Example:
  ///   Text(AppHelpers.getGreeting()) // 'Good Morning' or 'সুপ্রভাত'
  static String getGreeting() {
    final hour = DateTime.now().hour;
    final isBn = isBangla;

    if (hour < 12) {
      return isBn ? 'সুপ্রভাত' : 'Good Morning';
    } else if (hour < 17) {
      return isBn ? 'শুভ অপরাহ্ন' : 'Good Afternoon';
    } else if (hour < 21) {
      return isBn ? 'শুভ সন্ধ্যা' : 'Good Evening';
    } else {
      return isBn ? 'শুভ রাত্রি' : 'Good Night';
    }
  }
}
