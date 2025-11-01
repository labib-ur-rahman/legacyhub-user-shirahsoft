import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_template/core/utils/theme/custom_themes/appbar_theme.dart';

/// Dynamic Status Bar Widget
/// Automatically adjusts status bar style based on background color
class DynamicStatusBar extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final SystemUiOverlayStyle? customOverlayStyle;

  const DynamicStatusBar({
    super.key,
    required this.child,
    this.backgroundColor,
    this.customOverlayStyle,
  });

  @override
  Widget build(BuildContext context) {
    // Get the appropriate status bar style
    SystemUiOverlayStyle overlayStyle;

    if (customOverlayStyle != null) {
      overlayStyle = customOverlayStyle!;
    } else if (backgroundColor != null) {
      overlayStyle = AppAppBarTheme.getStatusBarStyleForColor(backgroundColor!);
    } else {
      // Use theme-based default
      final brightness = Theme.of(context).brightness;
      overlayStyle = brightness == Brightness.light
          ? AppAppBarTheme.lightAppBarTheme.systemOverlayStyle!
          : AppAppBarTheme.darkAppBarTheme.systemOverlayStyle!;
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: child,
    );
  }
}

/// Scaffold with Dynamic Status Bar
/// Automatically configures status bar based on scaffold background
class DynamicScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? backgroundColor;
  final bool extendBodyBehindAppBar;
  final bool extendBody;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final bool resizeToAvoidBottomInset;
  final bool primary;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const DynamicScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
    this.extendBodyBehindAppBar = false,
    this.extendBody = false,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.resizeToAvoidBottomInset = true,
    this.primary = true,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context) {
    // Get background color
    final bgColor =
        backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;

    return DynamicStatusBar(
      backgroundColor: bgColor,
      child: Scaffold(
        appBar: appBar,
        body: body,
        floatingActionButton: floatingActionButton,
        drawer: drawer,
        endDrawer: endDrawer,
        backgroundColor: backgroundColor,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        extendBody: extendBody,
        bottomNavigationBar: bottomNavigationBar,
        bottomSheet: bottomSheet,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        primary: primary,
        floatingActionButtonLocation: floatingActionButtonLocation,
      ),
    );
  }
}

/// Status Bar Helper Utilities
class StatusBarHelper {
  StatusBarHelper._();

  /// Set status bar style based on color
  static void setStatusBarStyle(Color backgroundColor) {
    final overlayStyle = AppAppBarTheme.getStatusBarStyleForColor(
      backgroundColor,
    );
    SystemChrome.setSystemUIOverlayStyle(overlayStyle);
  }

  /// Set status bar to light (dark icons)
  static void setLightStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  /// Set status bar to dark (light icons)
  static void setDarkStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  /// Reset status bar to theme default
  static void resetStatusBar(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    if (brightness == Brightness.light) {
      setLightStatusBar();
    } else {
      setDarkStatusBar();
    }
  }

  /// Get status bar height
  static double getStatusBarHeight(BuildContext context) {
    return MediaQuery.of(context).viewPadding.top;
  }

  /// Check if color is light or dark
  static bool isLightColor(Color color) {
    return color.computeLuminance() > 0.5;
  }

  /// Get contrasting text color for a background
  static Color getContrastingTextColor(Color backgroundColor) {
    return isLightColor(backgroundColor) ? Colors.black : Colors.white;
  }

  /// Get contrasting icon color for a background
  static Color getContrastingIconColor(Color backgroundColor) {
    return isLightColor(backgroundColor) ? Colors.black87 : Colors.white;
  }
}
