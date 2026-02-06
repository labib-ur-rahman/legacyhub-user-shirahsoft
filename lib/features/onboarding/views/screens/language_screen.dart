import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';
import 'package:legacyhub/core/localization/app_string_localizations.dart';
import 'package:legacyhub/features/onboarding/controllers/onboarding_language_controller.dart';
import 'package:legacyhub/features/onboarding/views/widgets/build_lottie_animation.dart';
import 'package:legacyhub/features/onboarding/views/widgets/build_next_button.dart';

/// Language Selection Screen - Second onboarding screen
/// Allows users to choose between English and Bangla languages
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingLanguageController());

    return Scaffold(
      backgroundColor: const Color(0xFFEEEFFC),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Lottie Animation
              SizedBox(height: 20.h),
              BuildLottieAnimation(lottieAnim: controller.getLottiePath()),

              SizedBox(height: 40.h),

              // Title
              _buildTitle(),

              SizedBox(height: 16.h),

              // Subtitle/Description
              _buildSubtitle(),

              SizedBox(height: 48.h),

              // Language Selector
              _buildLanguageSelector(controller),

              const Spacer(),

              // Get Started Button
              BuildNextButton(onTap: () => controller.completeOnboarding()),
            ],
          ),
        ),
      ),
    );
  }

  /// Build gradient title
  Widget _buildTitle() {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFF38B3FF), Color(0xFF0031FF)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(bounds),
      child: Text(
        AppStrings.chooseLanguage,
        style: getBoldTextStyle(fontSize: 24, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Build subtitle description
  Widget _buildSubtitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Text(
        AppStrings.chooseLanguageSubtitle,
        style: getTextStyle(fontSize: 15, color: Colors.black87),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Build language selector (English/Bangla toggle)
  Widget _buildLanguageSelector(OnboardingLanguageController controller) {
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
            final isBangla =
                controller.selectedLanguage.value.languageCode == 'bn';
            return AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: isBangla ? 152.w : 0,
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

          // English button
          Positioned(
            left: 0,
            child: GestureDetector(
              onTap: controller.selectEnglish,
              child: Container(
                width: 150.w,
                height: 53.h,
                alignment: Alignment.center,
                child: Obx(() {
                  final isSelected =
                      controller.selectedLanguage.value.languageCode == 'en';
                  return Text(
                    AppStrings.english,
                    style: getBoldTextStyle(
                      fontSize: 18,
                      color: isSelected ? Colors.black : Colors.white,
                    ),
                  );
                }),
              ),
            ),
          ),

          // Bangla button
          Positioned(
            right: 0,
            child: GestureDetector(
              onTap: controller.selectBangla,
              child: Container(
                width: 150.w,
                height: 53.h,
                alignment: Alignment.center,
                child: Obx(() {
                  final isSelected =
                      controller.selectedLanguage.value.languageCode == 'bn';
                  return Text(
                    AppStrings.bangla,
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
