import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:legacyhub/features/splash/controllers/splash_controller.dart';
import 'package:legacyhub/features/splash/views/widgets/splash_background.dart';
import 'package:legacyhub/features/splash/views/widgets/splash_loading_dots.dart';
import 'package:legacyhub/features/splash/views/widgets/splash_logo.dart';
import 'package:legacyhub/features/splash/views/widgets/splash_tagline.dart';
import 'package:legacyhub/features/splash/views/widgets/splash_text.dart';

/// Splash Screen - Initial loading screen with branding
///
/// Features:
/// - Animated gradient background with particles
/// - Animated logo with bounce effect
/// - Animated text with staggered letters
/// - Handles app initialization and navigation
///
/// Architecture:
/// - StatelessWidget (logic in SplashController)
/// - Modular widget components
/// - Clean separation of concerns
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    Get.put(SplashController());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: const Scaffold(body: _SplashContent()),
    );
  }
}

/// Splash content with all animated components
class _SplashContent extends StatelessWidget {
  const _SplashContent();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // Background with gradient and animated particles
          const SplashBackground(),

          // Centered content (logo + text + tagline + dots)
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated logo
                  const SplashLogo(),

                  // Spacing
                  SizedBox(height: 24.h),

                  // Animated text
                  const SplashText(),

                  // Spacing
                  SizedBox(height: 12.h),

                  // Tagline
                  const SplashTagline(),

                  // More spacing before loading dots
                  SizedBox(height: 48.h),

                  // Loading dots
                  const SplashLoadingDots(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
