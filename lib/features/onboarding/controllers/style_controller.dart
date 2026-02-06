import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legacyhub/core/services/local_storage_service.dart';
import 'package:legacyhub/core/services/logger_service.dart';
import 'package:legacyhub/core/utils/constants/app_style_colors.dart';

/// Style Controller - Manages app style selection and persistence
///
/// Responsibilities:
/// - Handle style selection (Shirah, Quepal, Timber, Flare, Amin, Midnight)
/// - Persist style preference
/// - Apply style colors to the app
/// - Sync with AppStyleColors singleton
class StyleController extends GetxController {
  static StyleController get instance => Get.find();

  // Selected app style (reactive)
  final Rx<AppStyle> selectedStyle = AppStyle.shirah.obs;

  // Reference to the color system
  final AppStyleColors _styleColors = AppStyleColors.instance;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentStyle();
  }

  /// Load current style from storage
  void _loadCurrentStyle() {
    try {
      final styleIndex = LocalStorageService.getAppStyle();
      AppStyle currentStyle;
      if (styleIndex is int &&
          styleIndex >= 0 &&
          styleIndex < AppStyle.values.length) {
        currentStyle = AppStyle.values[styleIndex];
      } else {
        currentStyle = AppStyle.shirah;
      }
      selectedStyle.value = currentStyle;
      _styleColors.setStyle(currentStyle);
      LoggerService.info('Current style loaded: ${currentStyle.name}');
    } catch (error) {
      LoggerService.error('Error loading style', error);
      selectedStyle.value = AppStyle.shirah;
      _styleColors.setStyle(AppStyle.shirah);
    }
  }

  /// Select a style
  void selectStyle(AppStyle style) {
    try {
      selectedStyle.value = style;

      // Update the color system
      _styleColors.setStyle(style);

      // Save to storage
      LocalStorageService.setAppStyle(style);

      LoggerService.info('Style changed to: ${style.name}');
    } catch (error) {
      LoggerService.error('Error selecting style', error);
    }
  }

  /// Check if a style is selected
  bool isSelected(AppStyle style) {
    return selectedStyle.value == style;
  }

  /// Get style display name
  String getStyleName(AppStyle style) {
    return _styleColors.getStyleName(style);
  }

  /// Get all available styles
  List<AppStyle> get allStyles => AppStyle.values;

  /// Get preview gradient for a style
  LinearGradient getPreviewGradient(AppStyle style) {
    return _styleColors.getPreviewGradient(style);
  }

  /// Get current app bar gradient
  LinearGradient get currentGradient => _styleColors.appBarGradient;

  /// Get current primary color
  Color get primaryColor => _styleColors.primary;

  /// Navigate to next screen (Login or Main based on flow)
  void navigateToNextScreen() {
    try {
      // Apply the selected style
      _styleColors.setStyle(selectedStyle.value);

      // Force UI update
      Get.forceAppUpdate();

      LoggerService.info('Style applied: ${selectedStyle.value.name}');

      // Go back to previous screen
      Get.back();
    } catch (error) {
      LoggerService.error('Error navigating from style screen', error);
      Get.back();
    }
  }

  /// Skip style selection and use default (Shirah) - just close the screen
  void skipStyleSelection() {
    try {
      // Apply current selected style and close
      _styleColors.setStyle(selectedStyle.value);
      LocalStorageService.setAppStyle(selectedStyle.value);

      // Force UI update
      Get.forceAppUpdate();

      LoggerService.info(
        'Style selection completed: ${selectedStyle.value.name}',
      );
      Get.back();
    } catch (error) {
      LoggerService.error('Error skipping style selection', error);
      Get.back();
    }
  }

  /// Apply style from settings (for settings screen usage)
  void applyStyleFromSettings(AppStyle style) {
    selectStyle(style);
    // Trigger UI rebuild by updating theme
    Get.forceAppUpdate();
  }
}
