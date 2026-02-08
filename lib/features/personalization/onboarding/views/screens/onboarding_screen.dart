import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:legacyhub/features/personalization/onboarding/controllers/onboarding_controller.dart';
import 'package:legacyhub/features/personalization/onboarding/views/widgets/onboarding_engine.dart';

/// ============================================================================
/// ONBOARDING SCREEN
/// ============================================================================
/// Entry point for the onboarding flow.
///
/// Responsibilities:
/// - Initializes OnboardingController via Get.put
/// - Sets system UI overlay style for immersive experience
/// - Delegates all UI to OnboardingEngine
///
/// Architecture:
///   OnboardingScreen (controller init)
///     └── OnboardingEngine (PageView orchestrator)
///           ├── AnimatedGradientBackground
///           ├── BackgroundCircles
///           ├── FlashLightTransition
///           ├── PageView.builder
///           │     └── OnboardingPage (per page)
///           │           ├── OnboardingLottie
///           │           └── OnboardingText / FeatureList
///           ├── SkipButton
///           ├── AnimatedDotIndicator
///           └── OnboardingButton
/// ============================================================================

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller — auto-disposed when screen is removed
    Get.put(OnboardingController());

    // Immersive status bar for gradient backgrounds
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return const OnboardingEngine();
  }
}
