import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';
import 'package:legacyhub/core/localization/app_string_localizations.dart';
import 'package:legacyhub/features/onboarding/controllers/theme_controller.dart';
import 'package:legacyhub/features/onboarding/views/widgets/build_lottie_animation.dart';
import 'package:legacyhub/features/onboarding/views/widgets/build_next_button.dart';

/// Theme Selection Screen - First onboarding screen
/// Allows users to choose between Dark and Light themes
class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ThemeController());

    return Obx(() {
      final bgColor = controller.getBackgroundColor();

      return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        color: bgColor,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Lottie Animation
                  SizedBox(height: 40.h),
                  BuildLottieAnimation(lottieAnim: controller.getLottiePath()),

                  SizedBox(height: 40.h),

                  // Title
                  _buildTitle(controller),

                  SizedBox(height: 16.h),

                  // Subtitle/Description
                  _buildSubtitle(controller),

                  SizedBox(height: 48.h),

                  // Theme Selector
                  _buildThemeSelector(controller),

                  const Spacer(),

                  // Next Button
                  BuildNextButton(onTap: () => controller.skipThemeSelection()),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  /// Build gradient title
  Widget _buildTitle(ThemeController controller) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFF38B3FF), Color(0xFF0031FF)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(bounds),
      child: Text(
        AppStrings.chooseTheme,
        style: getBoldTextStyle(fontSize: 24, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Build subtitle description
  Widget _buildSubtitle(ThemeController controller) {
    final isDark = controller.selectedTheme.value == ThemeMode.dark;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Text(
        AppStrings.chooseThemeSubtitle,
        style: getTextStyle(
          fontSize: 15,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Build theme selector (Dark/Light toggle)
  Widget _buildThemeSelector(ThemeController controller) {
    return Container(
      width: 302.w,
      height: 53.h,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Stack(
        children: [
          // Animated selector background
          Obx(() {
            final isLight = controller.selectedTheme.value == ThemeMode.light;
            return AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: isLight ? 152.w : 0,
              child: Container(
                width: 150.w,
                height: 53.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
            );
          }),

          // Dark button
          Positioned(
            left: 0,
            child: GestureDetector(
              onTap: () => controller.selectTheme(ThemeMode.dark),
              child: Container(
                width: 150.w,
                height: 53.h,
                alignment: Alignment.center,
                child: Obx(() {
                  final isSelected =
                      controller.selectedTheme.value == ThemeMode.dark;
                  return Text(
                    AppStrings.darkTheme,
                    style: getBoldTextStyle(
                      fontSize: 18,
                      color: isSelected ? Colors.black : Colors.white,
                    ),
                  );
                }),
              ),
            ),
          ),

          // Light button
          Positioned(
            right: 0,
            child: GestureDetector(
              onTap: () => controller.selectTheme(ThemeMode.light),
              child: Container(
                width: 150.w,
                height: 53.h,
                alignment: Alignment.center,
                child: Obx(() {
                  final isSelected =
                      controller.selectedTheme.value == ThemeMode.light;
                  return Text(
                    AppStrings.lightTheme,
                    style: getBoldTextStyle(
                      fontSize: 18,
                      color: isSelected ? Colors.black : Colors.white,
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
