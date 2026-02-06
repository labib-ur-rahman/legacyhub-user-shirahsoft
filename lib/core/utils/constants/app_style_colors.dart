import 'package:flutter/material.dart';

/// App Style Enum - Defines available app styles
/// Each style provides a unique color theme for the app
enum AppStyle {
  shirah, // Blue gradient (Default - LegacyHub brand)
  quepal, // Green gradient
  timber, // Orange/Red gradient
  flare, // Orange sunset gradient
  amin, // Purple gradient
  midnight, // Dark grey gradient
}

/// App Style Colors - Dynamic color system based on selected style
/// Provides colors that change based on user's selected app style
///
/// Usage:
///   final colors = AppStyleColors.instance;
///   Container(color: colors.primary);
///   AppBar(gradient: colors.appBarGradient);
class AppStyleColors extends ChangeNotifier {
  // Singleton pattern with ChangeNotifier for reactive updates
  static final AppStyleColors _instance = AppStyleColors._internal();
  static AppStyleColors get instance => _instance;
  factory AppStyleColors() => _instance;
  AppStyleColors._internal();

  // Current app style (default: shirah)
  AppStyle _currentStyle = AppStyle.shirah;
  ThemeMode _currentTheme = ThemeMode.light;

  /// Get current style
  AppStyle get currentStyle => _currentStyle;

  /// Get current theme
  ThemeMode get currentTheme => _currentTheme;

  /// Update the current style
  void setStyle(AppStyle style) {
    if (_currentStyle != style) {
      _currentStyle = style;
      notifyListeners();
    }
  }

  /// Update the current theme mode
  void setTheme(ThemeMode theme) {
    if (_currentTheme != theme) {
      _currentTheme = theme;
      notifyListeners();
    }
  }

  /// Check if currently in dark mode
  bool get isDarkMode => _currentTheme == ThemeMode.dark;

  // ============================================================================
  // GRADIENT COLORS (for App Bar)
  // ============================================================================

  /// App bar gradient based on current style
  LinearGradient get appBarGradient => _getAppBarGradient(_currentStyle);

  /// Get gradient for specific style
  LinearGradient _getAppBarGradient(AppStyle style) {
    switch (style) {
      case AppStyle.shirah:
        // Blue gradient (LegacyHub brand)
        return const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF006AED), Color(0xFF00C6FF)],
        );
      case AppStyle.quepal:
        // Green gradient
        return const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF38EF7D), Color(0xFF11998E)],
        );
      case AppStyle.timber:
        // Orange/Red sunset gradient
        return const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFFC00FF), Color(0xFF00DBDE)],
        );
      case AppStyle.flare:
        // Orange fire gradient
        return const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFF12711), Color(0xFFF5AF19)],
        );
      case AppStyle.amin:
        // Purple gradient
        return const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
        );
      case AppStyle.midnight:
        // Dark grey gradient
        return const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF232526), Color(0xFF414345)],
        );
    }
  }

  // ============================================================================
  // PRIMARY COLORS
  // ============================================================================

  /// Primary color based on current style
  Color get primary => _getPrimaryColor(_currentStyle);

  /// Get primary color for specific style
  Color _getPrimaryColor(AppStyle style) {
    switch (style) {
      case AppStyle.shirah:
        return const Color(0xFF006AED); // Blue
      case AppStyle.quepal:
        return const Color(0xFF11998E); // Teal
      case AppStyle.timber:
        return const Color(0xFF00DBDE); // Cyan
      case AppStyle.flare:
        return const Color(0xFFF12711); // Red-Orange
      case AppStyle.amin:
        return const Color(0xFF4A00E0); // Purple
      case AppStyle.midnight:
        return const Color(0xFF414345); // Dark Grey
    }
  }

  /// Light version of primary
  Color get primaryLight => _getPrimaryLightColor(_currentStyle);

  Color _getPrimaryLightColor(AppStyle style) {
    switch (style) {
      case AppStyle.shirah:
        return const Color(0xFF00C6FF);
      case AppStyle.quepal:
        return const Color(0xFF38EF7D);
      case AppStyle.timber:
        return const Color(0xFFFC00FF);
      case AppStyle.flare:
        return const Color(0xFFF5AF19);
      case AppStyle.amin:
        return const Color(0xFF8E2DE2);
      case AppStyle.midnight:
        return const Color(0xFF5A5A5A);
    }
  }

  // ============================================================================
  // SECONDARY COLORS
  // ============================================================================

  Color get secondary => _getSecondaryColor(_currentStyle);

  Color _getSecondaryColor(AppStyle style) {
    switch (style) {
      case AppStyle.shirah:
        return const Color(0xFFFFE24B); // Yellow
      case AppStyle.quepal:
        return const Color(0xFFAAE98F); // Light green
      case AppStyle.timber:
        return const Color(0xFFFF9EE7); // Pink
      case AppStyle.flare:
        return const Color(0xFFFFD93D); // Yellow
      case AppStyle.amin:
        return const Color(0xFFD4A5FF); // Light purple
      case AppStyle.midnight:
        return const Color(0xFF8E8E93); // Grey
    }
  }

  // ============================================================================
  // BACKGROUND COLORS
  // ============================================================================

  /// Background color based on style and theme
  Color get background => isDarkMode ? _darkBackground : _lightBackground;

  Color get _lightBackground {
    switch (_currentStyle) {
      case AppStyle.shirah:
        return const Color(0xFFF3F5FF); // Light blue tint
      case AppStyle.quepal:
        return const Color(0xFFF0FFF4); // Light green tint
      case AppStyle.timber:
        return const Color(0xFFFFF5F8); // Light pink tint
      case AppStyle.flare:
        return const Color(0xFFFFF8F0); // Light orange tint
      case AppStyle.amin:
        return const Color(0xFFF8F0FF); // Light purple tint
      case AppStyle.midnight:
        return const Color(0xFFF5F5F5); // Light grey
    }
  }

  Color get _darkBackground {
    switch (_currentStyle) {
      case AppStyle.shirah:
        return const Color(0xFF0D1117);
      case AppStyle.quepal:
        return const Color(0xFF0D1512);
      case AppStyle.timber:
        return const Color(0xFF150D12);
      case AppStyle.flare:
        return const Color(0xFF15110D);
      case AppStyle.amin:
        return const Color(0xFF110D15);
      case AppStyle.midnight:
        return const Color(0xFF0D0D0D);
    }
  }

  // ============================================================================
  // SURFACE COLORS (for cards, containers)
  // ============================================================================

  Color get surface => isDarkMode ? _darkSurface : _lightSurface;

  Color get _lightSurface {
    switch (_currentStyle) {
      case AppStyle.shirah:
        return const Color(0xFFFFFFFF);
      case AppStyle.quepal:
        return const Color(0xFFFFFFFF);
      case AppStyle.timber:
        return const Color(0xFFFFFFFF);
      case AppStyle.flare:
        return const Color(0xFFFFFFFF);
      case AppStyle.amin:
        return const Color(0xFFFFFFFF);
      case AppStyle.midnight:
        return const Color(0xFFFFFFFF);
    }
  }

  Color get _darkSurface {
    switch (_currentStyle) {
      case AppStyle.shirah:
        return const Color(0xFF161B22);
      case AppStyle.quepal:
        return const Color(0xFF1A2420);
      case AppStyle.timber:
        return const Color(0xFF221A1E);
      case AppStyle.flare:
        return const Color(0xFF221E1A);
      case AppStyle.amin:
        return const Color(0xFF1E1A22);
      case AppStyle.midnight:
        return const Color(0xFF1A1A1A);
    }
  }

  // ============================================================================
  // TEXT COLORS
  // ============================================================================

  Color get textPrimary =>
      isDarkMode ? const Color(0xFFFFFFFF) : const Color(0xFF1A1A1A);

  Color get textSecondary =>
      isDarkMode ? const Color(0xFFB0B0B0) : const Color(0xFF6C757D);

  Color get textOnPrimary => const Color(0xFFFFFFFF);

  Color get textOnGradient => const Color(0xFFFFFFFF);

  // ============================================================================
  // ACTION COLORS (for buttons, icons)
  // ============================================================================

  Color get actionActive => primary;

  Color get actionInactive =>
      isDarkMode ? const Color(0xFF6C757D) : const Color(0xFFB0B0B0);

  // ============================================================================
  // BORDER COLORS
  // ============================================================================

  Color get border =>
      isDarkMode ? const Color(0xFF30363D) : const Color(0xFFE1E4E8);

  Color get borderFocused => primary;

  // ============================================================================
  // STATUS COLORS (consistent across styles)
  // ============================================================================

  Color get success => const Color(0xFF28A745);
  Color get error => const Color(0xFFDC3545);
  Color get warning => const Color(0xFFFFC107);
  Color get info => const Color(0xFF17A2B8);

  // ============================================================================
  // ICON COLORS
  // ============================================================================

  Color get iconPrimary => primary;

  Color get iconSecondary =>
      isDarkMode ? const Color(0xFFB0B0B0) : const Color(0xFF6C757D);

  Color get iconOnGradient => const Color(0xFFFFFFFF);

  // ============================================================================
  // SHADOW COLORS
  // ============================================================================

  Color get shadow =>
      isDarkMode ? const Color(0x40000000) : primary.withValues(alpha: 0.15);

  // ============================================================================
  // BOTTOM NAV BAR COLORS
  // ============================================================================

  Color get bottomNavBackground =>
      isDarkMode ? const Color(0xFF161B22) : const Color(0xFFFFFFFF);

  Color get bottomNavActiveIcon => primary;

  Color get bottomNavInactiveIcon =>
      isDarkMode ? const Color(0xFF8B949E) : const Color(0xFF6C757D);

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Get style display name
  String getStyleName(AppStyle style) {
    switch (style) {
      case AppStyle.shirah:
        return 'Shirah';
      case AppStyle.quepal:
        return 'Quepal';
      case AppStyle.timber:
        return 'Timber';
      case AppStyle.flare:
        return 'Flare';
      case AppStyle.amin:
        return 'Amin';
      case AppStyle.midnight:
        return 'Midnight';
    }
  }

  /// Get style preview gradient (for style picker UI)
  LinearGradient getPreviewGradient(AppStyle style) {
    return _getAppBarGradient(style);
  }

  /// Get all available styles
  List<AppStyle> get allStyles => AppStyle.values;
}
