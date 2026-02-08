import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legacyhub/core/localization/app_string_localizations.dart';
import 'package:legacyhub/core/utils/constants/lottie_path.dart';
import 'package:legacyhub/features/personalization/onboarding/controllers/theme_controller.dart';
import 'package:legacyhub/features/personalization/onboarding/views/widgets/animated_onboarding_screen.dart';
import 'package:legacyhub/features/personalization/onboarding/views/widgets/material_tab_selector.dart';
import 'package:legacyhub/features/personalization/onboarding/views/widgets/circular_lottie_animation.dart';

/// Theme Selection Screen - First onboarding screen
/// Allows users to choose between Dark and Light themes
class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ThemeController.instance;

    return Obx(() {
      final isDark = controller.selectedTheme.value == ThemeMode.dark;
      final lottieAsset = isDark
          ? LottiePath.darkNight
          : LottiePath.lightSunSpin;
      final bgColor = controller.getBackgroundColor();
      final statusText = isDark
          ? (Get.locale?.languageCode == 'bn'
                ? 'ডার্ক নির্বাচিত'
                : 'Dark selected')
          : (Get.locale?.languageCode == 'bn'
                ? 'লাইট নির্বাচিত'
                : 'Light selected');

      return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        color: bgColor,
        child: AnimatedOnboardingScreen(
          lottieWidget: CircularLottieAnimation(
            lottieAsset: lottieAsset,
            size: 200,
          ),
          title: AppStrings.chooseTheme,
          description: AppStrings.chooseThemeSubtitle,
          selector: MaterialTabSelector(
            leftOption: AppStrings.darkTheme,
            rightOption: AppStrings.lightTheme,
            selectedIndex: isDark ? 0 : 1,
            onToggle: (index) {
              if (index == 0) {
                controller.selectTheme(ThemeMode.dark);
              } else {
                controller.selectTheme(ThemeMode.light);
              }
            },
            backgroundColor: Colors.black,
            indicatorColor: Colors.white,
            height: 56,
            width: 340,
          ),
          onNext: () => controller.skipThemeSelection(),
          bottomText: statusText,
          backgroundColor: bgColor,
          showBackgroundCircles: true,
          descriptionStyle: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.white70 : const Color(0xFF6B7280),
            height: 1.5,
          ),
        ),
      );
    });
  }
}
