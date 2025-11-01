import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// -- Light and Dark AppBar Themes with Dynamic Status Bar ---
class AppAppBarTheme {
  AppAppBarTheme._();

  /// -- Light Theme
  static AppBarTheme lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: const IconThemeData(color: Colors.black, size: 24),
    actionsIconTheme: const IconThemeData(color: Colors.black, size: 24),
    titleTextStyle: const TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    // Dynamic status bar style based on background
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  );

  /// -- Dark Theme
  static AppBarTheme darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: const IconThemeData(color: Colors.white, size: 24),
    actionsIconTheme: const IconThemeData(color: Colors.white, size: 24),
    titleTextStyle: const TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    // Dynamic status bar style based on background
    systemOverlayStyle: SystemUiOverlayStyle.light,
  );

  /// Get dynamic status bar style based on background color
  static SystemUiOverlayStyle getStatusBarStyle(Color backgroundColor) {
    // Calculate luminance to determine if background is light or dark
    final luminance = backgroundColor.computeLuminance();

    // If background is light (luminance > 0.5), use dark status bar
    // If background is dark (luminance <= 0.5), use light status bar
    if (luminance > 0.5) {
      return SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      );
    } else {
      return SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      );
    }
  }

  /// Get status bar style for a specific color with custom logic
  static SystemUiOverlayStyle getStatusBarStyleForColor(Color color) {
    final luminance = color.computeLuminance();

    // Custom thresholds for better visual results
    if (luminance > 0.6) {
      // Very light backgrounds (white, light gray, etc.)
      return SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      );
    } else if (luminance > 0.3) {
      // Medium backgrounds (medium gray, some colors)
      return SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      );
    } else {
      // Dark backgrounds (black, dark gray, dark colors)
      return SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      );
    }
  }
}
